package appointments

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(['ROLE_ADMIN', 'ROLE_LECTURER'])
@Transactional(readOnly = true)
class OfficeHourGroupController {

    static allowedMethods = ["POST", "GET"]

    def springSecurityService
    def officeHourService

    def show(OfficeHourGroup officeHourGroup) {
        respond officeHourGroup
    }

    def create() {
        Lecturer lecturer = springSecurityService.getCurrentUser()
        List<Lecturer> assistantOf = officeHourService.getLecturerUserIsAssistantOf((User)lecturer)
        def officeHourGroup = new OfficeHourGroup(params)
        respond officeHourGroup, model: [currentUser: lecturer, assistantOf: assistantOf]
    }

    @Transactional
    def save(OfficeHourGroup officeHourGroup) {
        if (officeHourGroup == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        Date startDate
        Date endDate
        Integer startHour
        Integer startMinute
        Integer endHour
        Integer endMinute
        String title = null
        String description = null

        if (params.title) title = params.title
        if (params.description) description = params.description

        int relativeDeadline = 0;
        if (params.relativeDeadline != null && params.relativeDeadline.trim() != "") {
            relativeDeadline = Integer.parseInt(params.relativeDeadline)
        }

        int maxDurationInMinutes = 0;
        if (params.maxDurationInMinutes != null && params.maxDurationInMinutes.trim() != "") {
            maxDurationInMinutes = Integer.parseInt(params.maxDurationInMinutes)
        }


        try {
            if (params.startDateVal) {
                long d = Long.parseLong(params.startDateVal)
                startDate = new Date(d)
            }

            if (params.endDateVal) {
                long d = Long.parseLong(params.endDateVal)
                endDate = new Date(d)
            } else {
                if (params.repeat == "on"){
                    flash.error = "Wenn Sie einen Serientermin anlegen möchten, geben Sie bitte den letzten Termin an."
                    redirect(action: 'create', params: params)
                    return
                }
                endDate = startDate

            }
        } catch (NumberFormatException e) {
            redirect action: 'create', params: params
            return
        }

        if (!startDate || !endDate) {
            flash.error = "Sie müssen ein gültiges Datum, Beginn und Ende angeben."
            redirect action: 'create', params: params
            return
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

        if (!startDate || !endDate || startHour == null || startMinute == null || endHour == null || endMinute == null) {
            if (!startDate) officeHourGroup.errors.reject("Es muss ein gültiges Datum angegeben werden. Bitte nutzen Sie das Format 'tt.mm.yyyy' .")
            if (!startHour || !startMinute) officeHourGroup.errors.reject("Es muss eine gültige Zeit für den Beginn angegeben werden.")
            if (!endHour || !endMinute) officeHourGroup.errors.reject("Es muss eine gültige Zeit für das Ende angegeben werden.")

            transactionStatus.setRollbackOnly()

            redirect(action: 'create', params: params)

            return
        }

        if (endHour < startHour) {
            officeHourGroup.errors.rejectValue("startHour", "officeHour.error.endsBeforeBegin")
        }

        User currentUser = springSecurityService.getCurrentUser()
        Lecturer currentLecturer = (Lecturer) springSecurityService.getCurrentUser()
        Lecturer lecturer = Lecturer.get(params.lecturer)

        // Check permissions
        List<Lecturer> assistantOf = officeHourService.getLecturerUserIsAssistantOf(currentUser)
        if (currentLecturer != lecturer && !assistantOf.contains(lecturer)){
            render "forbidden"
            return
        }

        // Create only one office hour
        if (startDate == endDate) {

            officeHourGroup = new OfficeHourGroup(lecturer: lecturer)

            OfficeHour officeHour = new OfficeHour()
            officeHour.start = DateUtils.setTime(startDate, startHour, startMinute)
            officeHour.end = DateUtils.setTime(endDate, endHour, endMinute)
            officeHour.deadline = DateUtils.substractHoursFromDate(officeHour.start, relativeDeadline)
            officeHour.maxDurationInMinutes = maxDurationInMinutes

            officeHour.officeHourGroup = officeHourGroup
            officeHour.lecturer = lecturer

            officeHour.publicTitle = title
            officeHour.publicDescription = description

            officeHourGroup.officeHours = [officeHour]

            if (officeHourGroup.hasErrors()) {
                transactionStatus.setRollbackOnly()
                respond officeHourGroup.errors, view:'create'
                return
            }

            officeHourGroup.save()
            officeHour.save()
        } else if (startDate < endDate) {
            officeHourGroup = new OfficeHourGroup(lecturer: lecturer)

            int dayInterval
            try {
                dayInterval = Integer.parseInt(params.repeatByDayInterval)
            } catch (NumberFormatException e) {
                flash.error = "Bitte geben Sie das Intervall an."
                redirect (action: 'create', params: params)
                return
            }

            Date processDate = startDate

            officeHourGroup.officeHours = new HashSet<>()

            while (processDate <= endDate) {
                OfficeHour officeHour = new OfficeHour()
                officeHour.start = DateUtils.setTime(processDate, startHour, startMinute)
                officeHour.end = DateUtils.setTime(processDate, endHour, endMinute)
                officeHour.deadline = DateUtils.substractHoursFromDate(officeHour.start, relativeDeadline)
                officeHour.maxDurationInMinutes = maxDurationInMinutes

                officeHour.officeHourGroup = officeHourGroup
                officeHour.lecturer = lecturer

                officeHour.publicTitle = title
                officeHour.publicDescription = description

                officeHourGroup.officeHours.add(officeHour)
                processDate = processDate + dayInterval
            }

            if (officeHourGroup.hasErrors()) {
                transactionStatus.setRollbackOnly()
                respond officeHourGroup.errors, view:'create'
                return
            }

            officeHourGroup.save()
            officeHourGroup.officeHours.each{ it.save() }
        }

        if (officeHourGroup.hasErrors() || officeHourGroup.officeHours.any{it.hasErrors()} ) {
            redirect(action: 'create', params: params)
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'officeHourGroup.label', default: 'OfficeHourGroup'), officeHourGroup.id])
                redirect officeHourGroup
            }
            '*' { respond officeHourGroup, [status: CREATED] }
        }
    }

    @Transactional
    def delete(OfficeHourGroup officeHourGroup) {

        if (officeHourGroup == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        officeHourGroup.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'officeHourGroup.label', default: 'OfficeHourGroup'), officeHourGroup.toString()])
                redirect controller: 'officeHour', action:'index'
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'officeHourGroup.label', default: 'OfficeHourGroup'), params.id])
                redirect controller: 'officeHour', action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
