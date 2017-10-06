package appointments

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_ADMIN'])
class ApplicationConfigController {

    static allowedMethods = ['POST', 'GET']

    def index() {
        render view: 'index', model: [config: ApplicationConfig.get(1)]
    }

    def update(ApplicationConfig applicationConfig) {
        ApplicationConfig ac = ApplicationConfig.get(1)
        bindData(ac, params)
        ac.save()

        flash.message = "Updated"

        redirect(view: 'index')
    }
}
