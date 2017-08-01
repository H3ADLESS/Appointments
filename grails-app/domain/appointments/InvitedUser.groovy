package appointments

class InvitedUser {

    String id
    String email
    User invitedBy

    static constraints = {
        email nullable: false, blank: false
        id generator: 'assigned'
        invitedBy nullable: false
    }
}
