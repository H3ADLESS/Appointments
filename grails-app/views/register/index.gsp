<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}" />
    <title>Einstellungen</title>
</head>
<body>

<div class="mdl-grid">

    <div class="mdl-cell mdl-cell--12-col">

        <h4>Nutzer registrieren</h4>
        <p>Nachfolgend können Sie Nutzer dazu einladen ihre Termine zukünftig über diese Anwendung zu planen. Der Nutzer kann sich dann per E-Mail und Passwort einloggen und benötigt keinen Sakai-Zugang. </p>

        <g:if test="${flash.message}">
            <div class="chip" style="width: 100%; height: auto; padding: 0.4em 2em;">
                ${flash.message}
                <i class="close material-icons">close</i>
            </div>
        </g:if>
    </div>

    <div class="mdl-cell mdl-cell--12-col">

        <form action="invite" method="post">
            <div class="row">
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                    <input class="mdl-textfield__input" type="text" id="email" name="email" placeholder="email@domain.de">
                    <label class="mdl-textfield__label" for="email">E-Mail</label>
                </div>
            </div>

            <input type="submit" name="update" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" value="Einladung senden" id="create">

        </form>

    </div>

<script>
    $(document).ready(function() {
        $('select').material_select();
    });
</script>

</body>
</html>