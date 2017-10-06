<%@ page import="appointments.Department; appointments.Lecturer" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}"/>
    <title>${entityName} - Einstellungen</title>
</head>

<body>

<div class="mdl-grid">

    <div class="mdl-cell mdl-cell--12-col">
        <h4><g:message code="profile"/></h4>
        <p>Geben Sie hier Ihre Profilinformationen an. Diese werden in der Übersicht für alle Nutzer angezeigt.</p>
    </div>

    <form action="update" method="post">

        <div class="mdl-cell mdl-cell--12-col">
            <b>Profil freigeben</b>

            <div class="switch" style="margin: 6px auto 20px auto">
                <label>
                    Inaktiv
                    <label class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="lecturer.active">
                        <input type="checkbox" id="lecturer.active" name="lecturer.active" class="mdl-switch__input"  ${lecturer?.active? 'checked' : ''}>
                        <span class="mdl-switch__label">Profil aktiv</span>
                    </label>
                    Aktiv
                </label>
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <b>Name</b> <br>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em">
                <input class="mdl-textfield__input" type="text" id="title" name="title" value="${lecturer?.title}">
                <label class="mdl-textfield__label" for="title">Anrede</label>
            </div>

            <br>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em;">
                <input class="mdl-textfield__input" type="text" id="firstName" name="firstName" value="${lecturer?.firstName}">
                <label class="mdl-textfield__label" for="firstName">Vorname</label>
            </div>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label m-width" style="width: 11em; margin-left: 1em">
                <input class="mdl-textfield__input" type="text" id="lastName" name="lastName" value="${lecturer?.lastName}">
                <label class="mdl-textfield__label" for="lastName">Nachname</label>
            </div>

        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <b>Foto</b> <br>

            <div class="circle" id="preview" style="background-image: url('${lecturer?.imageUrl}')"> </div>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 23em">
                <input class="mdl-textfield__input" type="text" id="imageUrl" name="imageUrl" value="${lecturer?.imageUrl}">
                <label class="mdl-textfield__label" for="imageUrl">Foto-URL</label>
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
        <b>E-Mail</b> <br>
            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 23em">
                <input class="mdl-textfield__input" type="text" id="email" name="email" value="${lecturer?.email}">
                <label class="mdl-textfield__label" for="email">E-Mail</label>
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
        <b>Adresse</b> <br>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 18em">
                <input class="mdl-textfield__input" type="text" id="street" name="street" value="${lecturer?.street}">
                <label class="mdl-textfield__label" for="street">Straße</label>
            </div>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 4em; margin-left: 1em;">
                <input class="mdl-textfield__input" type="text" id="number" name="number" value="${lecturer?.number}">
                <label class="mdl-textfield__label" for="number">Nummer</label>
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em">
                <input class="mdl-textfield__input" type="text" id="zip" name="zip" value="${lecturer?.zip}">
                <label class="mdl-textfield__label" for="zip">Postleitzahl</label>
            </div>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em; margin-left: 1em;">
                <input class="mdl-textfield__input" type="text" id="city" name="city" value="${lecturer?.city}">
                <label class="mdl-textfield__label" for="city">Ort</label>
            </div>

        </div>

        <div class="mdl-cell mdl-cell--12-col">

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em">
                <input class="mdl-textfield__input" type="text" id="floor" name="floor" value="${lecturer?.floor}">
                <label class="mdl-textfield__label" for="floor">Etage</label>
            </div>

            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" style="width: 11em; margin-left: 1em;">
                <input class="mdl-textfield__input" type="text" id="room" name="room" value="${lecturer?.room}">
                <label class="mdl-textfield__label" for="room">Raum</label>
            </div>

        </div>

        <div class="mdl-cell mdl-cell--12-col">
        <b>Fachbereich(e)</b> <br>

        <g:set var="lecturerDepartments" value="${lecturer?.departments?.id}"/>

        <div class="mdl-cell mdl-cell--12-col">
            <div class="input-field col s12">
                <select id="departments" name="departments" multiple>
                    <option value="" disabled selected>Choose your option</option>
                    <g:each in="${appointments.Department.findAll()}">
                        <option value="${it.id}" ${lecturerDepartments?.contains(it.id) ? "selected" : ""}>${it.name}</option>
                    </g:each>
                </select>
                <label for="departments">Fachbereich</label>
            </div>
        </div>

        <input type="submit" name="update" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" value="${message(code: "default.button.update.label")}" id="create">

    </form>
</div>

<script>
    $(document).ready(function () {
        $("#imageUrl").on('change', function () {
            console.log("change");
            $("#preview").css("background-image", " url(" + $("#imageUrl").val() + ")");
        })
    });
</script>

</body>

