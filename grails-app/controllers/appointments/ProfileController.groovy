package appointments

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_ADMIN', 'ROLE_LECTURER'])
class ProfileController {

    static allowedMethods = ['POST', 'GET']

    def springSecurityService

    def index() {
        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()
        render(view:"index", model: [lecturer: lecturer])
    }

    def disableTutorial(){
        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()
        lecturer.showTutorial = false;
        lecturer.save()
        render "ok"
    }

    def update() {
        Lecturer lecturer = (Lecturer)springSecurityService.getCurrentUser()

        lecturer.title = params.title
        lecturer.firstName = params.firstName
        lecturer.lastName = params.lastName

        if(params.lecturer?.active != null) {
            if (params.lecturer.active == "on") lecturer.active = true
        } else {
            lecturer.active = false
        }

        if(params.imageUrl) lecturer.imageUrl = params.imageUrl

        if (params.email) lecturer.email = params.email
        if (params?.email?.size() == 0){
            if (lecturer.userSettings.arrangementType == ArrangementType.USE_MAIL) {
                flash.message = "Mail is used for new appointments."
            } else {
                lecturer.email = null
            }
        }

        lecturer.street = params.street
        lecturer.number = params.number
        lecturer.city = params.city
        lecturer.zip = params.zip
        lecturer.floor = params.floor
        lecturer.room = params.room

        lecturer.departments = Department.getAll(params.departments)

        if (lecturer.userSettings == null) {
            lecturer.userSettings = new UserSettings()
            lecturer.userSettings.lecturer = lecturer
            lecturer.userSettings.save()
        }

        lecturer.save()

        render (view: 'index', model: [lecturer: lecturer])

    }
}
