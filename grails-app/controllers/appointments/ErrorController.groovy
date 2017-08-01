package appointments

import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class ErrorController {

    static allowedMethods = ['POST', 'GET']

    def unauthorized() {
        render (view: 'unauthorized')
    }
}
