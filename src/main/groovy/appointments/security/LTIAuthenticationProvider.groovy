package appointments.security

import org.springframework.context.MessageSourceAware
import org.springframework.security.authentication.AuthenticationProvider
import org.springframework.security.core.Authentication
import org.springframework.security.core.AuthenticationException
import org.springframework.util.Assert

/**
 * Created by H3ADLESS on 26.02.2017.
 */
class LTIAuthenticationProvider implements AuthenticationProvider {

    @Override
    Authentication authenticate(Authentication authentication) throws AuthenticationException, MessageSourceAware {
        Assert.isInstanceOf(LTIAuthenticationToken.class, authentication, "LTIAuthenticationProvider only supports LTIAuthenticationTokens.")

        LTIAuthenticationToken auth = (Authentication) authentication
//        if (auth.credentials) {
//            return new UsernamePasswordAuthenticationToken(auth.principal, auth.authorities)
            return auth
//            return auth
//        }
//        return null
    }

    @Override
    boolean supports(Class<?> authentication) {
        return LTIAuthenticationToken.class.isAssignableFrom(authentication)
    }

}
