package appointments

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(view:"/home/index")
        "500"(view:'/error')
        "403"(view:'/forbidden')
        "404"(view:'/notFound')
        "401"(view:'/error/unauthorized')
    }
}
