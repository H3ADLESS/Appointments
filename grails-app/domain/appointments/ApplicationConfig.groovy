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

    String applicationLogo1x
    String applicationLogo2x
    String applicationLogo3x
    String applicationLogoMobile

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

        applicationLogo1x nullable: true
        applicationLogo2x nullable: true
        applicationLogo3x nullable: true
        applicationLogoMobile nullable: true
    }

    static mapping = {
        applicationLogo1x defaultValue: "'/assets/fu-logo-1x.png'"
        applicationLogo2x defaultValue: "'/assets/fu-logo-2x.png'"
        applicationLogo3x defaultValue: "'/assets/fu-logo-3x.png'"
        applicationLogoMobile defaultValue: "'/assets/fu-logo-mobile.png'"
    }

}
