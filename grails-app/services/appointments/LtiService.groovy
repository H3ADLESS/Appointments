package appointments

import appointments.security.PasswordGen
import grails.transaction.Transactional

@Transactional
class LtiService {

    def parseRoles(def params) {
        if (params.roles){
            String[] roles = params.roles.split(",")
            ApplicationConfig config = ApplicationConfig.get(1)

            String admin = config.litRoleAdmin
            String instructor = config.litRoleInstructor
            String assistant = config.ltiRoleTeachingAssistant
            String student = config.ltiRoleStudent

            if(roles.contains(admin)){
                return LtiRole.LTI_ADMIN
            } else if (roles.contains(instructor)) {
                return LtiRole.LTI_INSTRUCTOR
            } else if (roles.contains(assistant)) {
                return LtiRole.LTI_TEACHING_ASSISTANT
            }
        }

        return LtiRole.LTI_STUDENT

    }

    def createUser(String firstName, String lastName, String userId, String email){
        User user = new User()
        user.title = ""
        user.firstName = firstName
        user.lastName = lastName
        user.username = userId
        user.password = PasswordGen.generate(32)
        user.email = email

        UserRole userRole = new UserRole()
        def role = Role.findByAuthority("ROLE_USER")

        userRole.user = user
        userRole.role = role

        user.save()
        userRole.save()

        return user;
    }

    def createLecturer(String firstName, String lastName, String userId, String email, role){
        def lecturer = new Lecturer()
        lecturer.firstName = firstName
        lecturer.lastName = lastName
        lecturer.email = email
        lecturer.username = userId
        lecturer.password = PasswordGen.generate(32)

        lecturer.departments = []
        lecturer.active = false

        lecturer.userSettings = new UserSettings()
        lecturer.userSettings.lecturer = lecturer
        lecturer.userSettings.arrangementType = ArrangementType.USE_APP
        lecturer.userSettings.preplanningInWeeks = 8
        lecturer.save()

        def lecturerUserRole = UserRole.create(lecturer, role).save()

        return lecturer
    }

}
