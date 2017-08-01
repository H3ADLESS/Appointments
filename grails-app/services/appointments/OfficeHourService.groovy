package appointments

import grails.gorm.DetachedCriteria
import grails.transaction.Transactional

@Transactional
class OfficeHourService {

    def springSecurityService

    def filter(Map params, Lecturer currentLecturer, List<Lecturer> assistantOf) {
        // ### SET FILTER ###
        // field for filter, default is currentLecturer
        Long lecturerFilterId = null
        if (currentLecturer) {
            lecturerFilterId = currentLecturer.id
        }

        // set filter from user input - if user is allowed to
        if (params.lecturerFilter) {
            Long tmpId = null
            try {
                tmpId = Long.parseLong(params.lecturerFilter)
                if (currentLecturer) {
                    if (currentLecturer.id == tmpId || assistantOf.contains(Lecturer.findById(tmpId))) {
                        lecturerFilterId = tmpId
                    }
                } else {
                    if (assistantOf.contains(Lecturer.findById(tmpId))) {
                        lecturerFilterId = tmpId
                    }
                }
            } catch (NumberFormatException e) {
                // ignore and use lecturerFilterId instead
            }
        }

        // ### GET DATA FROM DB ###
        def criteria = new DetachedCriteria(OfficeHour)
        criteria = criteria.build {
            if (lecturerFilterId != null) {
                eq("lecturer", Lecturer.findById(lecturerFilterId))
            } else {
                'in' ("lecturer", assistantOf)
            }

            // Don't show office hours by user they set another arrangement type than USE_APP
            and {
                lecturer{
                    userSettings{
                        eq ("arrangementType", ArrangementType.USE_APP )
                    }
                }
            }

            if (params.hidePastAppointments == "true"){
                gt('end', DateUtils.resetTime(new Date()))
            }

            if (params.dateFilter) {
                Date d1 = DateUtils.resetTime(new Date(Long.parseLong(params.dateFilter)))
                Date d2 = DateUtils.getEndOfDay(d1)
                between ("start", d1, d2)
            }
        }

        return [criteria.list(offset: params.offset, max: params.max, sort: params.sort, order: params.order), criteria.count()]

    }

    /**
     * Returns a list of lecturers who are assisted by the given user
     * @param user
     * @return lecturers who are assisted by the given user
     */
    def List<Lecturer> getLecturerUserIsAssistantOf(User user) {
        List<Lecturer> assistantOf = Lecturer.withCriteria {
            assistants {
                eq('id', user.id)
            }
        }

        return assistantOf
    }


    def boolean userHasPermissionForOfficeHour(OfficeHour officeHour){
        User user = springSecurityService.getCurrentUser()
        if (officeHour.lecturer == user) {
            return true
        }

        List<Lecturer> lecturersUserIsAssistantOf = getLecturerUserIsAssistantOf(user)
        if (lecturersUserIsAssistantOf.contains(officeHour.lecturer)) {
            return true
        }

        return false
    }

}
