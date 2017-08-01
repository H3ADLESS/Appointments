package appointments.notfications;

/**
 * Created by H3ADLESS on 16.04.2017.
 */
public enum NotificationType {

    APPOINTMENT_RESCHEDULED ("APPOINTMENT_RESCHEDULED"),
    APPOINTMENT_CANCELED("APPOINTMENT_CANCELED"),
    APPOINTMENT_CREATED("APPOINTMENT_CREATED")

    String name

    NotificationType(String name) {
        this.name = name;
    }

}