package appointments

class UserSettings {

    // Use app, email or website
    ArrangementType arrangementType

    // How many weeks are shown
    int preplanningInWeeks

    // Notification Settings
    boolean onAppointmentChange
    boolean onAppointmentCreation
    boolean onAppointmentCancellation

    String externalWebsite

    static hasOne = [lecturer : Lecturer]

    static mapping = {
        arrangementType defaultValue: ArrangementType.USE_APP
        preplanningInWeeks defaultValue: 8
    }

    static constraints = {
        lecturer nullable: false
        arrangementType nullable: false
        preplanningInWeeks nullable: false
        onAppointmentChange defaultValue: false
        onAppointmentCreation defaultValue: false
        onAppointmentCancellation defaultValue: false
        externalWebsite nullable: true, url: true
    }
}
