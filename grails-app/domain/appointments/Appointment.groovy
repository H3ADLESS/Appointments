package appointments

class Appointment {

    String title
    String firstName
    String lastName

    String subject

    Date start
    Date end

    User user

    static transients = ['maxDuration', 'duration']
    int maxDuration
    int duration

    static belongsTo = [officeHour : OfficeHour]

    static mapping = {
    }

    static constraints = {
        title nullable: true
        subject nullable: false, maxSize: 512
        duration bindable: true
    }

    def getCurrentDuration() {
        return DateUtils.getTimeDifferenceInMinutes(start, end)
    }

    def rescheduleTo(Date newStart, OfficeHour newOfficeHour = null){
        int duration = getCurrentDuration()
        Date newEnd = DateUtils.addMinutesToDate(newStart, duration)
        this.start = newStart
        this.end = newEnd
        if (newOfficeHour) {
            this.officeHour = newOfficeHour
            this.save()
        }
    }

}
