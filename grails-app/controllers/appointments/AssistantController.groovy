package appointments

import grails.plugin.springsecurity.annotation.Secured

@Secured("hasAnyRole('ROLE_LECTURER', 'ROLE_ADMIN')")
class AssistantController {

    static allowedMethods = ['POST', 'GET']

    def springSecurityService

    def index() {
        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()

        render (view: 'index', model: [assistants: lecturer.assistants])
    }

    def search () {
        List<User> user = []
        if (params.name && params.name.size() > 2) {
            user = User.findAllByNameIlike("%" + params.name + "%")
        }

        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()
        user.removeAll(lecturer.assistants)
        user.remove((User) lecturer)

        render(template: 'result', model: [user: user])
    }

    def add () {
        User user = User.get(params.id)

        Lecturer lecturer = (Lecturer) springSecurityService.getCurrentUser()

        if (lecturer.assistants.contains(user)) {
            redirect(view: 'index');
            return
        }

        if (lecturer != null) {
//            user.lecturers.add(lecturer)
            lecturer.assistants.add(user)
            lecturer.save()
            user.save()
        }

        redirect(view: 'index');

    }

    def remove () {
        User user = User.get(params.id)

        Lecturer lecturer = springSecurityService.getCurrentUser()
//        Lecturer lecturer = currentUser.lecturer

        if (lecturer != null) {
            lecturer.assistants.remove(user)
//            user.lecturers.remove(lecturer)

            lecturer.save()
            user.save()
        }

        redirect(view: 'index')

    }

}
