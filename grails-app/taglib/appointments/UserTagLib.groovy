package appointments

class UserTagLib {
//    static defaultEncodeAs = [taglib:'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    def springSecurityService

    def ifUserIsAssistantOrLecturer = { attrs, body ->
        User user = springSecurityService.getCurrentUser()
        if (user == null) return
        def lecturerCriteria = Lecturer.createCriteria()
        def list = lecturerCriteria.list (max: 1) {
            assistants {
                idEq(user.id)
            }
        }
        def isLecturer = (user instanceof Lecturer)
        if (list.size() > 0 || isLecturer) {
            def writer = out
            writer << body()
        }
    }

    def ifTutorialEnabled = { attrs, body ->
        User user = springSecurityService.getCurrentUser()
        if (user == null) return
        def isLecturer = (user instanceof Lecturer)
        if (isLecturer) {
            if(Lecturer.get(user.id).showTutorial) {
                def writer = out
                writer << body()
            }
        }
    }

    def ifUserIsLecturerAndProfileIsActive = { attrs, body ->
        User user = springSecurityService.getCurrentUser()
        if (user == null) return
        def isLecturer = (user instanceof Lecturer)
        if (isLecturer) {
            def lecturer = Lecturer.get(user.id)
            if(lecturer.active) {
                out << body()
            }
        }
    }

    def ifUserIsLecturerAndProfileIsInactive = { attrs, body ->
        User user = springSecurityService.getCurrentUser()
        if (user == null) return
        def isLecturer = (user instanceof Lecturer)
        if (isLecturer) {
            def lecturer = Lecturer.get(user.id)
            if(!lecturer.active) {
                out << body()
            }
        }
    }

    def username = { attrs, body ->
        def writer = out
        User user = springSecurityService.getCurrentUser()
        if (user == null) return
        def isLecturer = (user instanceof Lecturer)
        if (isLecturer) {
            Lecturer lecturer = (Lecturer) user
            writer << "Hallo " + lecturer.name
        } else {
            if (user.name != null && user.name.trim() != "") {
                writer << "Hallo " + user.name
            } else {
                writer << "Hallo " + user.username
            }
        }
    }

}
