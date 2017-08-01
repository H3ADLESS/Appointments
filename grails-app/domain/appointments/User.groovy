package appointments

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

	private static final long serialVersionUID = 1

	transient springSecurityService

	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	// User Data
	String email
	String username 		// used as login-name: guests should enter their E-Mail here / Sakai login uses sakai-id

	String title
	String firstName
	String lastName
	String name				// Search String

	// assistant of (?)
//	static hasMany = [lecturers: Lecturer]

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this)*.role
	}

	def beforeValidate() {
		name = [title, firstName, lastName].findAll().join(" ")
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}

	static transients = ['springSecurityService']

	static constraints = {
		password blank: false, password: true
		username blank: false, unique: true
		email blank: false, unique: true

		// User Data
		title blank: true, nullable: true
		firstName blank: false, nullable: true
		lastName blank: false, nullable: false
		name blank: false, nullable: false
//		lecturer nullable: true
	}

	static mapping = {
		password column: '`password`'
		tablePerHierarchy false
	}
}
