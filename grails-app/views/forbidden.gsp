<!doctype html>
<html>
<head>
    <title>403 - Forbidden</title>
    <meta name="layout" content="mdl-main-layout"/>
    <g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
</head>

<body>


<header>
    <g:render template="/layouts/mdl-nav"/>
</header>

<main>
    <div class="container">
         <div class="row">
            <g:if env="development">
                <g:if test="${Throwable.isInstance(exception)}">
                    <g:renderException exception="${exception}" />
                </g:if>
                <g:elseif test="${request.getAttribute('javax.servlet.error.exception')}">
                    <g:renderException exception="${request.getAttribute('javax.servlet.error.exception')}" />
                </g:elseif>
                <g:else>
                    <ul class="errors">
                        <li> 403 - Forbidden </li>
                        %{--<li>Exception: ${exception}</li>--}%
                        %{--<li>Message: ${message}</li>--}%
                        %{--<li>Path: ${path}</li>--}%
                    </ul>
                </g:else>
            </g:if>
            <g:else>
                <ul class="errors">
                    <li> 403 - Forbidden </li>
                </ul>
            </g:else>

         </div>
    </div>
</main>

</body>
</html>
