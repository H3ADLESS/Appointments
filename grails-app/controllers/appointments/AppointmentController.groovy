package appointments

import appointments.notfications.NotificationType
import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured("hasAnyRole('ROLE_USER', 'ROLE_LECTURER', 'ROLE_ADMIN')")
@Transactional(readOnly = true)
class AppointmentController {

    static allowedMethods = ['POST', 'GET']

    def springSecurityService
    def appointmentService
    def appointmentsMailService

    def index() {
        Lecturer lecturer = Lecturer.get(params.id)
        User user = springSecurityService.getCurrentUser()

        if (lecturer.userSettings.arrangementType != ArrangementType.USE_APP) {
            def model = [arrangementType: lecturer.userSettings.arrangementType,
                         website: lecturer.userSettings.externalWebsite,
                         lecturer: lecturer]
            render (view: 'link', model: model)
            return
        }

        def officeHours

        if (params.date) {
            Date d = new Date(params.long("date"))
            officeHours = appointmentService.getOfficeHourSlots(lecturer, d)
        } else {
            officeHours = appointmentService.getOfficeHourSlots(lecturer, null)
        }

        def dates = appointmentService.getOfficeHourDates(lecturer)

        Long prevOhDate = null
        Long nextOhDate = null
        if (officeHours?.size() > 0) {
            Date currentOhDate = officeHours[0].date
            def nextOfficeHour = appointmentService.getNextOfficeHourAfter(currentOhDate, lecturer)
            def prevOfficeHour = appointmentService.getPrevOfficeHourBefore(currentOhDate, lecturer)
            if (prevOfficeHour != null && prevOfficeHour.start != null) {
                prevOhDate = DateUtils.resetTime(prevOfficeHour.start).getTime()
            }
            if (nextOfficeHour != null && nextOfficeHour.start != null) {
                nextOhDate = DateUtils.resetTime(nextOfficeHour.start).getTime()
            }
        }

        def model = [officeHours:officeHours, dates: dates, lecturer: lecturer, user: user, prevOhDate: prevOhDate, nextOhDate: nextOhDate]
        render (view: 'index', model: model)
    }

    def list() {
        User user = springSecurityService.getCurrentUser()
        List<Appointment> appointments = []
        if (params.hidePast == null || params.hidePast == "true"){
            params.hidePast = "true"
            appointments = Appointment.findAllByUserAndEndGreaterThan(user, DateUtils.resetTime(new Date()))
        } else {
            appointments = Appointment.findAllByUser(user)
        }
        render (view: 'list', model: [appointments: appointments], params: [hidePast: params.hidePast])
    }

    def show(Appointment appointment) {
        User user = springSecurityService.getCurrentUser()
        if (user == appointment.user || appointment.officeHour.lecturer == user) {
            respond appointment
            return
        }

        response.status = 401
        render (controller: 'error', action:'unauthorized')
    }

    def successful(Appointment appointment) {
        User user = springSecurityService.getCurrentUser()
        if (user == appointment.user || appointment.officeHour.lecturer == user) {
            respond (appointment, view: 'successful')
            return
        }

        response.status = 401
        render (controller: 'error', action:'unauthorized')
    }

    def create() {
        Appointment appointment = new Appointment()

        Long dateAsLong = params.long("date")
        if (dateAsLong == null || dateAsLong == 0L){
            render view: 'index'
        }
        appointment.start = new Date(dateAsLong)

        OfficeHour officeHour = OfficeHour.get(params.long("officeHour"))
        if (officeHour == null) {
            render(view: 'index', params: ["date":dateAsLong])
        }
        appointment.officeHour = officeHour

        User user = springSecurityService.getCurrentUser()
        if (user == null) {
            render(view: 'index', params: ["date":dateAsLong])
        }
        appointment.user = user

        appointmentService.setMaxDuration(params, officeHour, appointment, user)
        appointment.end = DateUtils.addMinutesToDate(appointment.start, appointment.duration)

        if (!appointmentService.checkIfFree(appointment)){
            redirect(controller: 'appointment', action: 'index', id: officeHour.lecturer.id ,params: [date: DateUtils.resetTime(officeHour.start).getTime()])
            return;
        }

        respond(view: 'create', appointment)
    }

    @Transactional
    def save(Appointment appointment) {
        //TODO: null checks & secure
        User currentUser = springSecurityService.getCurrentUser()

        if (!appointment.officeHour) {
            response.sendError(500)
            return
        }

        if (appointment.officeHour.deadline < new Date()){
            if (appointment.officeHour.lecturer != currentUser){
                flash.error = "Termine für diese Sprechstunde können nicht mehr gebucht werden! Der Dozent hat eine Deadline festgelegt."
                redirect(action: 'create', params: params)
                return
            }
        }

        if (!appointment.subject) {
            flash.error = "Bitte gib einen Grund für deinen Termin an!"
            redirect(action: 'create', params: params)
            return
        }

        appointment.user = springSecurityService.getCurrentUser()
        appointment.start = new Date(params.long("date"))
        appointment.end = DateUtils.addMinutesToDate(appointment.start, appointment.duration)
        boolean success = appointmentService.checkBlockedAndCreate(appointment)

        if (success) {
            appointmentsMailService.sendAppointmentNotification(appointment, NotificationType.APPOINTMENT_CREATED)
            redirect (action: 'successful', id: appointment.id)
            return
        } else {
            int maxDuration = appointmentService.getMaxDuration(appointment.officeHour, appointment.start)
            appointment.maxDuration = maxDuration
            flash.error = "Dieser Termin ist bereits vergeben!"
            redirect (action: 'index', id: appointment.officeHour.lecturer.id, params: [date: DateUtils.resetTimeAndGetTime(appointment.officeHour.start)])
            return
        }
    }

    def edit(Appointment appointment) {
        respond appointment
    }

    @Transactional
    def update(Appointment appointment) {
        if (!appointmentService.authorized(appointment)) {
            render(controller: 'error', action: 'unauthorized')
            return
        }

        if (appointment == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (appointment.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond appointment.errors, view:'edit'
            return
        }

        appointment.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'appointment.label', default: 'Appointment'), appointment.id])
                redirect appointment
            }
            '*'{ respond appointment, [status: OK] }
        }
    }

    @Transactional
    def delete(Appointment appointment) {

        if (!appointmentService.authorized(appointment)) {
            render(controller: 'error', action: 'unauthorized')
            return
        }

        if (appointment == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        // TODO: notify participants

        appointment.delete flush:true

        flash.message = "Ihr Termin '${appointment.subject}' wurde erfolgreich abgesagt."
//                message(code: 'default.deleted.message', args: [message(code: 'appointment.label', default: 'Appointment'), appointment.id])

        redirect (action: 'list')
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'appointment.label', default: 'Appointment'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
