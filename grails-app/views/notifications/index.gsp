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
        <h4><g:message code="userSettings.notifications"/></h4>
        <p>Wählen Sie nachfolgend, wann Sie über Änderungen informiert werden möchten.</p>

        <g:if test="${flash.message}">
            <div class="mdl-chip">
                <span class="mdl-chip__text">${flash.message}</span>
                %{--<button type="button" class="mdl-chip__action"><i class="material-icons">cancel</i></button>--}%
            </div>
        </g:if>
    </div>

    <div class="mdl-cell mdl-cell--12-col">
        <g:form controller="notifications" action="update">

            <div class="mdl-grid">

                <div class="mdl-cell mdl-cell--12-col">
                    <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="onAppointmentCreation">
                        <input id="onAppointmentCreation" name="onAppointmentCreation" type="checkbox" class="mdl-checkbox__input" ${lecturer?.userSettings?.onAppointmentCreation? 'checked' : ''}>
                        <span class="mdl-checkbox__label">Bei neuen Terminvereinbarungen</span>
                    </label>

                </div>
                <div class="mdl-cell mdl-cell--12-col">
                    <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="onAppointmentChange">
                        <input id="onAppointmentChange" name="onAppointmentChange" type="checkbox" class="mdl-checkbox__input" ${lecturer?.userSettings?.onAppointmentChange? 'checked' : ''}>
                        <span class="mdl-checkbox__label">Bei Terminänderungen</span>
                    </label>

                </div>
                <div class="mdl-cell mdl-cell--12-col">
                    <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="onAppointmentCancellation">
                        <input id="onAppointmentCancellation" name="onAppointmentCancellation" type="checkbox" class="mdl-checkbox__input" ${lecturer?.userSettings?.onAppointmentCancellation? 'checked="checked"' : ''}>
                        <span class="mdl-checkbox__label">Bei Absagen</span>
                    </label>
                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <div class="input-field col s12">
                        <input type="submit" name="update" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" value="${message(code: "default.button.update.label")}" id="create">
                    </div>
                </div>
            </div>
        </g:form>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('select').material_select();
    });
</script>

</body>

