<%@ page import="appointments.ArrangementType; appointments.Department; appointments.Lecturer" %>
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
        <h4><g:message code="userSettings.arrangementType"/></h4>
        <p>Sie können nachfolgend wählen, wie Termine mit Ihnen vereinbart werden sollen. <br> Wenn Sie die Vereinbarung per E-Mail oder Website wählen, dient diese Applikation lediglich zur Weiterleitung.</p>

        <g:if test="${flash.message}">
            <div class="chip" style="width: 100%; height: auto; padding: 0.4em 2em;">
                ${flash.message}
                <i class="close material-icons">close</i>
            </div>
        </g:if>
    </div>

    <div class="mdl-cell mdl-cell--12-col">
        <div class="mdl-grid">
            <g:form controller="arrangementType" action="update">

                %{--<div class="mdl-cell mdl-cell--12-col">--}%
                    %{--<input name="arrangementType" value="${ArrangementType.USE_APP}" type="radio" id="webapp" ${lecturer?.userSettings?.arrangementType == ArrangementType.USE_APP ? 'checked="checked"' : ''} />--}%
                    %{--<label for="webapp"><g:message code="userSettings.arrangementType.radioLabel.webapp"/> </label>--}%
                %{--</div>--}%

                <div class="mdl-cell mdl-cell--12-col">
                    <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="webapp">
                        <input name="arrangementType" value="${ArrangementType.USE_APP}" type="radio" id="webapp" class="mdl-radio__button" ${lecturer?.userSettings?.arrangementType == ArrangementType.USE_APP ? 'checked="checked"' : ''}>
                        <span class="mdl-radio__label"><g:message code="userSettings.arrangementType.radioLabel.webapp"/></span>
                    </label>
                </div>

                %{--<div class="mdl-cell mdl-cell--12-col">--}%
                    %{--<input name="arrangementType" value="${ArrangementType.USE_MAIL}" type="radio" id="email" ${lecturer?.userSettings?.arrangementType == ArrangementType.USE_MAIL ? 'checked="checked"' : ''} />--}%
                    %{--<label for="email"><g:message code="userSettings.arrangementType.radioLabel.email"/> </label>--}%
                %{--</div>--}%

                <div class="mdl-cell mdl-cell--12-col">
                    <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="email">
                        <input name="arrangementType" value="${ArrangementType.USE_MAIL}" type="radio" id="email" ${lecturer?.userSettings?.arrangementType == ArrangementType.USE_MAIL ? 'checked="checked"' : ''} class="mdl-radio__button">
                        <span class="mdl-radio__label"><g:message code="userSettings.arrangementType.radioLabel.email"/></span>
                    </label>
                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <div style="padding-left: 4em">
                    <span>Diese E-Mail-Adresse wird automatisch für Ihr Profil übernommen.</span> <br>
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <input class="mdl-textfield__input" type="text" id="emailAddress" name="emailAddress" value="${lecturer?.email}">
                            <label class="mdl-textfield__label" for="emailAddress">E-Mail</label>
                        </div>
                    </div>
                </div>

                %{--<div class="mdl-cell mdl-cell--12-col">--}%
                    %{--<input name="arrangementType" value="${ArrangementType.USE_EXTERNAL_WEBSITE}" type="radio" id="externalWebsite" ${lecturer?.userSettings?.arrangementType == ArrangementType.USE_EXTERNAL_WEBSITE ? 'checked="checked"' : ''} />--}%
                    %{--<label for="externalWebsite" ><g:message code="userSettings.arrangementType.radioLabel.externalWebsite"/> </label>--}%
                %{--</div>--}%

                <div class="mdl-cell mdl-cell--12-col">
                    <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="externalWebsite">
                        <input name="arrangementType" value="${ArrangementType.USE_EXTERNAL_WEBSITE}" type="radio" id="externalWebsite" ${lecturer?.userSettings?.arrangementType == ArrangementType.USE_EXTERNAL_WEBSITE ? 'checked="checked"' : ''} class="mdl-radio__button">
                        <span class="mdl-radio__label"><g:message code="userSettings.arrangementType.radioLabel.externalWebsite"/> </span>
                    </label>
                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <div style="padding-left: 4em">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <input class="mdl-textfield__input" type="text" id="externalWebsiteUrl" name="externalWebsiteUrl" value="${lecturer?.userSettings?.externalWebsite}" placeholder="http://www.example.com">
                            <label class="mdl-textfield__label" for="externalWebsiteUrl">URL</label>
                        </div>
                    </div>
                </div>

                <input type="submit" name="update" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" value="${message(code: "default.button.update.label")}" id="create"/>

            </g:form>
        </div>
    </div>
</div>

<script>

    $(':radio').on('change', radioChange);

    function radioChange() {
        $("#externalWebsiteUrl").prop('disabled', $(":radio:checked").val() != '${ArrangementType.USE_EXTERNAL_WEBSITE}');
        $("#emailAddress").prop('disabled', $(":radio:checked").val() != '${ArrangementType.USE_MAIL}');
    }

    $(document).ready(function () {
        $('select').material_select();
        radioChange();
        Materialize.updateTextFields();
    });
</script>

</body>

