package appointments

import grails.plugin.springsecurity.annotation.Secured

class RegisterController {

    static allowedMethods = ['POST', 'GET']

    def mailService
    def springSecurityService

    @Secured(['ROLE_ADMIN', 'ROLE_LECTURER'])
    def index() {
        render view: 'index'
    }

    @Secured(['ROLE_ADMIN', 'ROLE_LECTURER'])
    def invite() {

        User user = springSecurityService.getCurrentUser()

        if (params.email == null) {
            flash.message = "Email must not be null."
            render (view: 'index')
            return
        }

        String email = params.email

        String uuid = UUID.randomUUID().toString()
        while (InvitedUser.findById(uuid) != null) {
            uuid = UUID.randomUUID().toString()
        }

        InvitedUser iu = new InvitedUser()
        iu.id = uuid
        iu.email = email
        iu.invitedBy = user

        if (iu.hasErrors()) {
            flash.message = "An error occurred. Please ask admin for help."
            render (view: 'index')
            return
        }

        boolean success = mailService.sendInviteTo(email, uuid)
        if (!success) {
            flash.message = "Error sending invitation. Please try again later."
            render (view: "index")
            return
        }

        iu.save()

        flash.message = "Einladung wurde versendet."
        render (view: "index")
    }

    // Register guests
    def guest() {

        InvitedUser iv = InvitedUser.findById(params.id)

        if ( iv == null || !params.submit ) {
            render (view: "guest", params: [id: params.id])
            return
        }

        if (!params.password || !params.matchPassword || params.password != params.matchPassword || !params.firstName || !params.lastName) {
            flash.message = ""
            if (!params.password || !params.matchPassword || params.password != params.matchPassword) {
                flash.message = "Please make sure your passwords are matching."
            } else {
                flash.message = "Please insert your name"
            }
            render (view: "guest", params: params)
            return
        }

        User user = new User()
        user.title = params.title
        user.firstName = params.firstName
        user.lastName = params.lastName
        user.password = params.password
        user.email = iv.email
        user.username = iv.email
        UserRole userRole = new UserRole()
        userRole.user = user
        userRole.role = Role.findByAuthority("ROLE_USER")
        ""
        user.save()
        userRole.save()
        iv.delete()

        redirect(controller: 'login')
    }

}
