package appointments

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured("hasAnyRole('ROLE_ADMIN')")
@Transactional(readOnly = true)
class DepartmentController {

    static allowedMethods = ['POST', 'GET']

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Department.list(params), model:[departmentCount: Department.count()]
    }

    @Transactional
    def save(Department department) {
        if (department == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (department.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond department.errors, view: 'index'
            return
        }

        department.save flush: true

        flash.message = message(code: 'default.created.message', args: [message(code: 'department.label', default: 'Fachbereich'), department.name])
        redirect(action: 'index')
    }

    @Transactional
    def delete(Department department) {

        if (department == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        List<Lecturer> lecturers = Lecturer.createCriteria().list {
            departments{
                eq('id', department.id)
            }
        }

        lecturers.each {
            it.departments.remove(department)
            it.save()
        }

        department.delete flush:true

        flash.message = message(code: 'default.deleted.message', args: [message(code: 'department.label', default: 'Fachbereich'), department.name])
        redirect action:"index"
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'department.label', default: 'Fachbereich'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
