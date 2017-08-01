package appointments

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_ADMIN'])
class ApplicationConfigController {

    static allowedMethods = ['POST', 'GET']

    def index() {
        render view: 'index', model: [config: ApplicationConfig.get(1)]
    }

    //TODO: update
}
