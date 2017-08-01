package appointments

class Department {

    String name
    String url

    static constraints = {
        name blank: false, nullable: false
        url nullable: true, url: true
    }
}
