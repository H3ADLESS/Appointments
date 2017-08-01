import appointments.ApplicationConfig
import appointments.Role

class BootStrap {

    def init = { servletContext ->

        if(ApplicationConfig.count() == 0) {
            def applicationConfig = new ApplicationConfig()
            applicationConfig.save()
        }

        if (Role.count() < 3) {
            new Role(authority: 'ROLE_ADMIN').save()
            new Role(authority: 'ROLE_USER').save()
            new Role(authority: 'ROLE_LECTURER').save()
        }
    }

    def destroy = {

    }

}
