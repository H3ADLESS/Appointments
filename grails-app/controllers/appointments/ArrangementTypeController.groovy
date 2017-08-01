package appointments

import grails.plugin.springsecurity.annotation.Secured

@Secured("hasAnyRole('ROLE_LECTURER', 'ROLE_ADMIN')")
class ArrangementTypeController {

    static allowedMethods = ['POST', 'GET']

    def springSecurityService

    def index() {
        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()
        render(view: 'index', model: [lecturer: lecturer])
    }

    def update() {
        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()
        UserSettings userSettings = lecturer.userSettings

        ArrangementType previous = userSettings.arrangementType

        if (params.arrangementType) {
            ArrangementType type = ArrangementType.valueOf(params.arrangementType)
            userSettings.arrangementType = type
        }

        if (params.externalWebsiteUrl) {
            userSettings.externalWebsite = params.externalWebsiteUrl
            if (userSettings.externalWebsite.trim().length() == 0) {
                userSettings.externalWebsite = null;
            }
        }

        if (params.emailAddress) {
            lecturer.email = params.emailAddress
            lecturer.save()
        }

        if (userSettings.arrangementType == ArrangementType.USE_MAIL && !lecturer.email) {
            userSettings.arrangementType = previous
            flash.message = "ERROR: Provide a valid E-Mail address."
            redirect (action: 'index')
            return
        }

        if (userSettings.arrangementType == ArrangementType.USE_EXTERNAL_WEBSITE && !userSettings.externalWebsite) {
            userSettings.arrangementType = previous
            flash.message = "ERROR: Provide a valid website."
            redirect (action: 'index')
            return
        }

        userSettings.save()

        if(userSettings.hasErrors()) {
            flash.message = "Error"
        } else {
            flash.message = "Successfully updated"
        }
        redirect view: 'index'
    }
}
