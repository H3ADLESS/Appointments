import appointments.ApplicationConfig
import appointments.Role

class BootStrap {

    def init = { servletContext ->

        if(ApplicationConfig.count() == 0) {
            def applicationConfig = new ApplicationConfig()
            applicationConfig.applicationLogo1x = "/assets/fu-logo-1x.png"
            applicationConfig.applicationLogo2x = "/assets/fu-logo-2x.png"
            applicationConfig.applicationLogo3x = "/assets/fu-logo-3x.png"
            applicationConfig.applicationLogoMobile = "/assets/fu-logo-mobile.png"
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
