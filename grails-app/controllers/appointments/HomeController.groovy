package appointments

import grails.plugin.springsecurity.annotation.Secured
import grails.transaction.Transactional

@Secured(['permitAll'])
@Transactional
class HomeController {

    static allowedMethods = ['POST', 'GET']

    def springSecurityService

    def index() {
        render view: 'index'
    }

    def search(String name, Long departmentId){
        List<Lecturer> results
        def c = Lecturer.createCriteria()
        results = c.list{
            if (name && name.trim() != "") {
                ilike("name", "%${name}%")
            }

            if (departmentId) {
                departments {
                    idEq(departmentId)
                }
            }
            eq("active", true)
            order("lastName")
        }

        def model = ["lecturers" : results]
        render (template: 'list', model: model)
    }

}
