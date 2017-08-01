package appointments

class Lecturer extends User{

    Boolean active
    Boolean showTutorial

    // Profile Information (public)
    String imageUrl

    // ### A D D R E S S ###
    String street
    String number
    String city
    String zip
    String floor
    String room

    // ### E M A I L ###
    String email

    // SEARCH TERMS
    String searchTerms

    // User Settings (private)
    UserSettings userSettings

    static hasMany = [departments: Department,
                      officeHours: OfficeHour,
                      assistants: User]

//    static belongsTo = User

    static mapping = {
        assistants joinTable: [name: 'assistants', column: 'assistant_user_id', key: 'lecturer_id']
        showTutorial defaultValue: true
    }

    static constraints = {
        showTutorial nullable: true
        searchTerms nullable: true, size: 0..1000
        active defaultValue: false
        imageUrl nullable: true
        departments nullable: false
        userSettings nullable: false
        street nullable: true
        number nullable: true
        city nullable: true
        zip nullable: true
        floor nullable: true
        room nullable: true
        email nullable: true
    }

}
