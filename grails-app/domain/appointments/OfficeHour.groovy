package appointments

class OfficeHour {

    // start & end
    Date start
    Date end

    String publicTitle
    String publicDescription

    Date deadline
    Integer maxDurationInMinutes

    static hasMany = [appointments:Appointment]

    static belongsTo = [lecturer:Lecturer, officeHourGroup: OfficeHourGroup]

    static constraints = {
        start nullable: false, validator: {val, obj -> obj.start && obj.end && obj.start < obj.end}
        end nullable: false, validator: {val, obj -> obj.start && obj.end && obj.start < obj.end}
        publicTitle maxSize: 255, nullable: true
        publicDescription maxSize: 1024, nullable: true
    }

    def String toString(){
        if (publicTitle && publicTitle != "") {
            return publicTitle
        } else {
            return "${id}"
        }
    }

}
