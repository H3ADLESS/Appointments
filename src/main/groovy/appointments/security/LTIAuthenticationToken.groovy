package appointments.security

import appointments.LtiRole
import appointments.User
import appointments.UserRole
import grails.plugin.springsecurity.userdetails.GrailsUser
import org.springframework.security.authentication.AbstractAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority

/**
 * Created by H3ADLESS on 26.02.2017.
 */
class LTIAuthenticationToken extends AbstractAuthenticationToken {

    Boolean credentials     // eg. password
    GrailsUser principal    // eg. username

    public LTIAuthenticationToken(boolean authenticated, User principal, String authority) {
        super([new SimpleGrantedAuthority(authority)])
//        authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"))

        def p = new GrailsUser(principal.email, "", true, true, true, true, [new SimpleGrantedAuthority(authority)], principal.id)

        this.principal = p
        this.credentials = authenticated
        super.setAuthenticated(authenticated)
    }

    @Override
    Object getCredentials() {
        return credentials
    }

    @Override
    Object getPrincipal() {
        return principal
    }

    @Override
    void setAuthenticated(boolean authenticated) throws IllegalArgumentException {
        if (authenticated) {
            throw new IllegalArgumentException(
                    "Cannot set this token to trusted - use constructor which takes a GrantedAuthority list instead");
        }

        super.setAuthenticated(false);
    }

    @Override
    String getName() {
        return principal;
    }

}