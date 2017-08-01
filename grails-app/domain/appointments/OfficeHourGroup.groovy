package appointments

class OfficeHourGroup {

    String name
    String description

    static hasMany = [officeHours:OfficeHour]

    static belongsTo = [lecturer : Lecturer]

    static constraints = {
        name nullable: true
        lecturer nullable: false
        description nullable: true
        officeHours nullable: false
    }

    def String toString(){
        if (name && name != "") {
            return name
        } else {
            return "${id}"
        }
    }

}
