<%@ page import="appointments.User; appointments.ArrangementType" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <title>Sprechstunden</title>
</head>
<body>

<main>

    <div>
        <div class="container">

            <div class="col s12" style="color: black">
                <a href="${createLink(controller: 'home')}" class="custom-breadcrumb">Termin vereinbaren</a>
                <a href="#!" class="custom-breadcrumb"> ${lecturer.name} </a>
            </div>

            <div class="row">
                <div class="col s12 m8">
                    Bitte vereinbare deinen Termin mit ${lecturer.name}
                    <g:if test="${arrangementType == ArrangementType.USE_EXTERNAL_WEBSITE}">
                        über die folgende Webseite: <a href="${website}">${website}</a>
                    </g:if>
                    <g:else>
                        per E-Mail:
                            <a href="mailto:${lecturer.email}?subject=Sprechstunde">
                                ${lecturer.email}
                            </a>
                    </g:else>
                </div>
            </div>
        </div>
    </div>
</main>

</body>
</html>