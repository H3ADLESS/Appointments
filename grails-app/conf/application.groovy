import appointments.security.LTIAuthenticationProvider

grails.plugin.springsecurity.providerNames = ['daoAuthenticationProvider']

// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.successHandler.defaultTargetUrl = '/home/index'

grails.plugin.springsecurity.userLookup.userDomainClassName = 'appointments.User'
grails.plugin.springsecurity.userLookup.usernamePropertyName='username'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'appointments.UserRole'
grails.plugin.springsecurity.authority.className = 'appointments.Role'
grails.plugin.springsecurity.controllerAnnotations.staticRules = [
	[pattern: '/',               access: ['permitAll']],
	[pattern: '/error',          access: ['permitAll']],
	[pattern: '/notFound',       access: ['permitAll']],
	[pattern: '/forbidden',      access: ['permitAll']],
	[pattern: '/home',           access: ['permitAll']],
	[pattern: '/home.gsp',       access: ['permitAll']],
	[pattern: '/shutdown',       access: ['permitAll']],
	[pattern: '/assets/**',      access: ['permitAll']],
	[pattern: '/**/js/**',       access: ['permitAll']],
	[pattern: '/**/css/**',      access: ['permitAll']],
	[pattern: '/**/images/**',   access: ['permitAll']],
	[pattern: '/**/favicon.ico', access: ['permitAll']],
	[pattern: '/lti/***', 		 access: ['permitAll']],
	[pattern: '/register/guest', access: ['permitAll']]
]

grails.plugin.springsecurity.filterChain.chainMap = [
	[pattern: '/assets/**',      filters: 'none'],
	[pattern: '/**/js/**',       filters: 'none'],
	[pattern: '/**/css/**',      filters: 'none'],
	[pattern: '/**/images/**',   filters: 'none'],
	[pattern: '/**/favicon.ico', filters: 'none'],
	[pattern: '/**',             filters: 'JOINED_FILTERS']
]

