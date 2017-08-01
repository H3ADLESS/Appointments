package appointments

import grails.plugin.springsecurity.annotation.Secured

@Secured("hasAnyRole('ROLE_LECTURER', 'ROLE_ADMIN')")
class NotificationsController {

    static allowedMethods = ['POST', 'GET']

    def springSecurityService

    def index() {
        User lecturer = (Lecturer) springSecurityService.getCurrentUser()

        if (lecturer.userSettings.arrangementType != ArrangementType.USE_APP) {
            flash.message = "Bitte ändere Deine Einstellungen, wenn du diese Webapplikation zur Organisation der Sprechstunden nutzen möchtest."
            redirect (controller: 'arrangementType')
            return
        }

        render(view: 'index', model: [lecturer: lecturer])
    }

    def update(){
        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()
        UserSettings userSettings = lecturer.userSettings

        userSettings.onAppointmentCancellation = (params?.onAppointmentCancellation == "on")
        userSettings.onAppointmentChange = (params?.onAppointmentChange == "on")
        userSettings.onAppointmentCreation = (params?.onAppointmentCreation == "on")

        userSettings.save()

        if(userSettings.hasErrors()) {
            flash.message = "Error"
        } else {
            flash.message = "Successfully updated"
        }
        redirect view: 'index'
    }
}
