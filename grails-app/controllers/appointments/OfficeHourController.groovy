package appointments

import grails.gorm.DetachedCriteria
import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(['ROLE_ADMIN', 'ROLE_LECTURER', 'ROLE_USER'])
@Transactional(readOnly = true)
class OfficeHourController {

    static allowedMethods = ['POST', 'GET']

    def springSecurityService
    def appointmentService
    def officeHourService

    def index(Integer max) {
        User user = springSecurityService.getCurrentUser()

        def assistantOf = officeHourService.getLecturerUserIsAssistantOf(user)
        def manageableLecturers = assistantOf
        def isLecturer = (user instanceof Lecturer)

        // If user is not assistant of a lecturer and is not a lecturer
        if (assistantOf.size() == 0 && !isLecturer) {
            render status: 403
            return
        }

        Lecturer lecturer
        if (user instanceof Lecturer) {
            lecturer = (Lecturer) user
            manageableLecturers.add(lecturer)
            if (!params.lecturerFilter) {
                params.lecturerFilter = lecturer.id.toString()
            }
            if (lecturer.userSettings.arrangementType != ArrangementType.USE_APP) {
                flash.message = "Bitte ändere Deine Einstellungen, wenn du diese Webapplikation zur Organisation der Sprechstunden nutzen möchtest."
                redirect (controller: 'arrangementType')
                return
            }
        } else {
            lecturer = null
        }

        params.max = Math.min(max ?: 10, 100)
        if(params.sort == null) params.sort = "start"

        if (params.hidePastAppointments == null){
            params.hidePastAppointments = "true"
        }

        List<OfficeHour> officeHours;
        int size
        (officeHours, size) = officeHourService.filter(params, lecturer, assistantOf)
        respond officeHours, model:[officeHourCount: size, lecturer: lecturer, assistantOf: assistantOf, manageableLecturers: manageableLecturers, hidePastAppointments: params.hidePastAppointments ]
    }

    def show(OfficeHour officeHour) {
        if (officeHour == null) {
            notFound()
            return
        }

        if (!officeHourService.userHasPermissionForOfficeHour(officeHour)){
            render status: 403
            return
        }

        def slots = appointmentService.getOfficeHourSlots(officeHour)
        respond (officeHour, model:[officeHours: slots])
    }

    def edit(OfficeHour officeHour) {
        if (!officeHourService.userHasPermissionForOfficeHour(officeHour)){
            render status: 403
            return
        }
        respond officeHour
    }

    // Move an office hour to a new time, maybe it's duration is shortened or extended. Then also move the related appointments.
    @Transactional
    def update(OfficeHour officeHour) {

        if (officeHour == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (!officeHourService.userHasPermissionForOfficeHour(officeHour)){
            render status: 403
            return
        }

        Date startDate
        Integer startHour
        Integer startMinute
        Integer endHour
        Integer endMinute

        if (params.startDateVal) {
            long d = Long.parseLong(params.startDateVal)
            startDate = new Date(d)
        }

        if(params.startTime){
            String startTime = params.startTime
            String[] startTimeArr = startTime.split(/[^0-9]/);
            if (startTimeArr.length == 2){
                startHour = Integer.parseInt(startTimeArr[0])
                startMinute = Integer.parseInt(startTimeArr[1])
            }
        }

        if(params.endTime){
            String endTime = params.endTime
            String[] endTimeArr = endTime.split(/[^0-9]/);
            if (endTimeArr.length == 2){
                endHour = Integer.parseInt(endTimeArr[0])
                endMinute = Integer.parseInt(endTimeArr[1])
            }
        }

        if (!startDate || startHour == null || startMinute == null || endHour == null || endMinute == null) {
            if (!startDate) officeHour.error.reject("Es muss ein gültiges Datum angegeben werden. Bitte nutzen Sie das Format 'tt.mm.yyyy' .")
            if (!startHour || !startMinute) officeHour.error.reject("Es muss eine gültige Zeit für den Beginn angegeben werden.")
            if (!endHour || !endMinute) officeHour.error.reject("Es muss eine gültige Zeit für das Ende angegeben werden.")

            transactionStatus.setRollbackOnly()
            respond officeHour.error, view:'edit'
            return
        }

        if (endHour < startHour) {
            officeHour.error.rejectValue("startHour", "officeHour.error.endsBeforeBegin")
        }

        User user = springSecurityService.getCurrentUser()

        officeHour.start = DateUtils.setTime(startDate, startHour, startMinute)
        officeHour.end = DateUtils.setTime(startDate, endHour, endMinute)

        if (officeHour.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond officeHour.errors, view:'edit'
            return
        }

        // TODO: Make sure that officeHour.save() doesn't fail and is not blocked by another officeHour
        // TODO: What happens if there are appointments left over?
        // TODO: let user decide whether to reschedule appointments or not
        if (officeHour.start > new Date()) {
            appointmentService.rescheduleAppointments(officeHour)
        }

        officeHour.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'officeHour.label', default: 'OfficeHour'), officeHour.id])
                redirect officeHour
            }
            '*'{ respond officeHour, [status: OK] }
        }
    }

    @Transactional
    def delete(OfficeHour officeHour) {

        if (officeHour == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (!officeHourService.userHasPermissionForOfficeHour(officeHour)){
            render status: 403
            return
        }

        // TODO: What happens if there are appointments left over?
        appointmentService.rescheduleAppointments(officeHour, true)
        officeHour.delete(flush:true)

        flash.message = message(code: 'default.deleted.message', args: [message(code: 'officeHour.label', default: 'OfficeHour'), officeHour.toString()])
        redirect action:"index", params: params
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'officeHour.label', default: 'OfficeHour'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
