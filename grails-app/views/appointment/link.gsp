<%@ page import="appointments.User; appointments.ArrangementType" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <title>Sprechstunden</title>
</head>
<body>

<main>

    <div class="mdl-grid">

        <div class="mdl-cell mdl-cell--12-col">
            <div class="stepper">
                <div class="step done">
                    <div class="stepper-cirlce">
                        <div style="margin: auto"><i class="material-icons">done</i></div>
                    </div>
                    <div class="stepper-text">
                        Dozent auswählen
                        %{--<a href="${createLink(controller: 'home', action: 'index')}">Dozent auswählen</a>--}%
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="step active">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">2</div>
                    </div>
                    <div class="stepper-text">
                        Termin vereinbaren
                    </div>
                </div>

            </div>
        </div>

        <div class="mdl-cell mdl-cell--8-col">
            <h4>Einen Termin bei ${lecturer?.title} ${lecturer?.firstName} ${lecturer?.lastName} vereinbaren</h4>
            <h6>

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
            </h6>
        </div>
        %{--</div>--}%
    </div>

</main>

</body>
</html>