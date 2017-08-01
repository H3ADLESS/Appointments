package appointments

class ApplicationConfig {

    // ### LTI SETTINGS ###
    String ltiKey
    String ltiSecret
    String litRoleAdmin                 // Admin
    String litRoleInstructor            // Lecturer
    String ltiRoleTeachingAssistant     // Assistant
    String ltiRoleStudent               // Student
    String sakaiUrl                       // Sakai Webadresse

    // ### MAIL SETTINGS ###
    String mailSmtpHost
    Boolean mailSmtpAuth
    Integer mailSmtpPort
    Integer mailSmtpSocketFactoryPort

    String emailUsername
    String emailPassword

    static constraints = {
        ltiKey nullable: true
        ltiSecret nullable: true
        litRoleAdmin nullable: true
        litRoleInstructor nullable: true
        ltiRoleTeachingAssistant nullable: true
        ltiRoleStudent nullable: true
        sakaiUrl nullable: true

        mailSmtpHost nullable: true
        mailSmtpAuth nullable: true
        mailSmtpPort nullable: true
        mailSmtpSocketFactoryPort nullable: true

        emailUsername nullable: true
        emailPassword nullable: true
    }

}
