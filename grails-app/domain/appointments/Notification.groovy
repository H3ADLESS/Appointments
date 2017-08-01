package appointments

import appointments.notfications.NotificationType

/**
 * Handles display notifications and mail-notifications.
 */
class Notification {

    String message
    User user

    NotificationType type

    Appointment relatedAppointment
    OfficeHour relatedOfficeHour

    Boolean mailSend
    Boolean notificationRead

    static constraints = {
        message nullable: false
        user nullable: false

        type nullable: true

        mailSend nullable: false, defaultValue: false
        notificationRead nullable: false, defaultValue: false

        relatedAppointment nullable: true
        relatedOfficeHour nullable: true
    }
}
