package appointments

import appointments.security.LTIAuthenticationProvider
import appointments.security.LTIAuthenticationToken
import appointments.security.PasswordGen
import grails.plugin.springsecurity.annotation.Secured
import org.grails.web.util.WebUtils
import org.imsglobal.lti.launch.LtiOauthVerifier
import org.imsglobal.lti.launch.LtiVerificationResult
import org.imsglobal.lti.launch.LtiVerifier
import org.springframework.security.core.context.SecurityContextHolder

import javax.servlet.http.HttpServletRequest

@Secured(['permitAll'])
class LtiController {

    static allowedMethods = ['POST', 'GET']

    def ltiService
    def springSecurityService

    def index() {

        HttpServletRequest request = WebUtils.retrieveGrailsWebRequest().getCurrentRequest()
        LtiVerifier ltiVerifier = new LtiOauthVerifier();

        if (!params.roles || !(params.lti_version == "LTI-1p0" || !params.user_id) ) {
            render "Access denied"
            return;
        }

        String key = request.getParameter("oauth_consumer_key");
        String dbKey = ApplicationConfig.get(1).ltiKey

        if (dbKey == key) {
            String dbSecret = ApplicationConfig.get(1).ltiSecret
            LtiVerificationResult ltiResult = ltiVerifier.verify(request, dbSecret);

            if(ltiResult.success) {
                // TODO: create session, get user if exists, create user if not or redirect to officeHour selection

                LtiRole ltiRole = ltiService.parseRoles(params)
                String userId = params.user_id

                String firstName
                String lastName

                if (params.lis_person_name_given) firstName = params.lis_person_name_given
                if (params.lis_person_name_family) lastName = params.lis_person_name_family

                User user = User.findByUsername(userId)
                if (user == null) {
                    //TODO: create new user

                    String email = null;
                    if (params.lis_person_contact_email_primary != null) {
                        email = params.lis_person_contact_email_primary
                    }

                    if (ltiRole == LtiRole.LTI_ADMIN) {
                        def role = Role.findByAuthority("ROLE_ADMIN")
                        user = ltiService.createLecturer(firstName, lastName, userId, email, role)
                    } else if (ltiRole == LtiRole.LTI_INSTRUCTOR) {
                        def role = Role.findByAuthority("ROLE_LECTURER")
                        user = ltiService.createLecturer(firstName, lastName, userId, email, role)
                    } else if (ltiRole == LtiRole.LTI_STUDENT) {
                        user = ltiService.createUser(firstName, lastName, userId, email)
                    }
                }

                // Log user in
                Role role = UserRole.findByUser(user).role
                String authority = UserRole.findByUser(user).role.authority
                def authentication = new LTIAuthenticationToken(true, user, authority)
                def auth = new LTIAuthenticationProvider().authenticate(authentication)
                SecurityContextHolder.getContext().setAuthentication(auth)
                redirect(controller: 'home', action: 'index')
                return
            }
        }

        render "Access denied"
    }



}
