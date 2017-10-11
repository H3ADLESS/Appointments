<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}" />
    <title>Einstellungen</title>
</head>
<body>

<div class="mdl-grid">
    <div class="mdl-cell--12-col">
        <g:if test="${flash.message}">
            <div class="chip" style="width: 100%; height: auto; padding: 0.4em 2em;">
                ${flash.message}
                <i class="close material-icons">close</i>
            </div>
        </g:if>
        <h4>Lege dein Passwort fest.</h4>
        <p>Bitte lege dein Passwort fest, mit dem du dich zukünftig anmelden möchtest.</p>

        <g:form action="guest">
            <div class="row">
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 8em">
                    <input class="mdl-textfield__input" id="title" name="title" type="text" value="${params.title}">
                    <label class="mdl-textfield__label" for="title">Anrede und Titel</label>
                </div>
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em">
                    <input class="mdl-textfield__input" id="firstName" name="firstName" type="text" value="${params.firstName}">
                    <label class="mdl-textfield__label" for="firstName">Vorname</label>
                </div>
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em">
                    <input class="mdl-textfield__input" id="lastName" name="lastName" type="text" value="${params.lastName}">
                    <label class="mdl-textfield__label" for="lastName">Nachname</label>
                </div>
            </div>
            <div class="row">
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                    <input class="mdl-textfield__input" id="password" name="password" type="password">
                    <label class="mdl-textfield__label" for="password">Password</label>
                </div>
            </div>
            <div class="row">
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                    <input class="mdl-textfield__input" id="matchPassword" name="matchPassword" type="password">
                    <label class="mdl-textfield__label" for="matchPassword">Password wiederholen</label>
                </div>
            </div>

            <input style="display: none" name="id" value="${params.id}"/>

            <input type="submit" name="submit" class="save btn" value="Ok">
        </g:form>
    </div>
</div>

</body>
</html>