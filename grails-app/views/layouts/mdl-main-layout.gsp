<%@ page import="appointments.ApplicationConfig" %>
<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="FU - Appointments"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <link rel="icon" type="image/x-ico" href="${ApplicationConfig.get(1)?.favIcon}"/>

    <asset:stylesheet src="custom.css"/>

    <asset:stylesheet src="material.css"/>
    <asset:javascript src="material.min.js"/>

    <asset:javascript src="jquery-3.1.0.min.js"/>
    <asset:stylesheet src="jquery-ui/jquery-ui.min.css"/>
    <asset:javascript src="jquery-ui/jquery-ui.min.js"/>

    <asset:javascript src="menu.js"/>

    <g:layoutHead/>
</head>
<body>

<div class="mdl-layout mdl-js-layout mdl-layout--fixed-drawer mdl-layout--no-drawer-button">

    <g:render template="/layouts/mdl-nav"/>

    <main class="mdl-layout__content">

        <div class="mdl-layout__drawer">
            <nav class="mdl-navigation">
                <ul class="menu-entries" style="margin: 0; padding: 0;">
                    <g:render template="/layouts/navigationEntries"/>
                </ul>
            </nav>
        </div>

        <g:layoutBody/>

    </main>

    <g:render template="/layouts/mdlFooter"/>

</div>

</body>
</html>
