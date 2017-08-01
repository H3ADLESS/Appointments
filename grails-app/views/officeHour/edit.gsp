<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>

    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'OfficeHour')}" />
    <title>Sprechstunde ändern</title>
</head>
<body>

<div class="mdl-grid">
    <div class="mdl-cell mdl-cell--12-col">

    <h4>Sprechstunde ändern</h4>

    </div>

    <g:form bean="officeHour" action="update" id="${this.officeHour?.id}">

        <div class="mdl-cell mdl-cell--12-col">
            <b>Titel und Beschreibung</b> <br>
            <div class="input-field col s12">
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-dirty time">
                    <input class="mdl-textfield__input" id="publicTitle" name="publicTitle" value="${this.officeHour?.publicTitle}">
                    <label class="mdl-textfield__label" for="publicTitle">Titel</label>
                </div>

                %{--<input id="publicTitle" name="publicTitle" type="text" value="${this.officeHour?.publicTitle}">--}%
                %{--<label for="publicTitle">Titel</label>--}%
            </div>
            <div class="input-field col s12">
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                    <textarea class="mdl-textfield__input" type="text" rows= "3" id="publicDescription" name="publicDescription" >${this.officeHour?.publicDescription}</textarea>
                    <label class="mdl-textfield__label" for="publicDescription">Beschreibung</label>
                </div>

                %{--<textarea id="publicDescription" name="publicDescription" class="materialize-textarea">${this.officeHour?.publicDescription}</textarea>--}%
                %{--<label for="publicDescription">Beschreibung</label>--}%
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <b>Datum und Zeit der Sprechstunde</b> <br>
            <div class="input-field col m4">
                %{--<input id="startDate" class="datepicker-start" type="text" name="startDate" value="${formatDate(date: this.officeHour.start, format: 'dd.MM.yyyy')}">--}%
                <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label time">
                    <input class="mdl-textfield__input datepicker-start" id="startDate" name="startDate" value="${formatDate(date: this.officeHour.start, format: 'dd.MM.yyyy')}">
                    <label class="mdl-textfield__label" for="publicTitle">Termin</label>
                </div>

                <input id="startDateVal" name="startDateVal" value="${this.officeHour?.start?.getTime()}" style="display:none;">
                %{--<label for="startDate">Termin</label>--}%
            </div>

            <div class="custom-input-container">
                <label for="startTime">Beginn</label>
                <input id="startTime" name="startTime" type="time" class="timepicker mdl-textfield__input" value="${formatDate(date: this.officeHour.start, format: 'HH:mm')}">
            </div>

            <br>

            <div class="custom-input-container">
                <label for="endTime">Ende</label>
                <input id="endTime" name="endTime" type="time" class="timepicker mdl-textfield__input" value="${formatDate(date: this.officeHour.end, format: 'HH:mm')}">
                %{--<label class="mdl-textfield__label" for="endTime">Termin</label>--}%
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col" style="margin-top: 2em;">
            <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="notifyParticipants">
                <input type="checkbox" id="notifyParticipants" name="notifyParticipants" class="mdl-checkbox__input" >
                <span class="mdl-checkbox__label">Teilnehmer benachrichtigen</span>
            </label>
        </div>

        <br>

        <div class="mdl-cell mdl-cell--12-col" >
            <input type="submit" name="update" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" value="Ändern" id="update">
            <a href="${createLink(controller: 'officeHour', action: 'delete', id: this.officeHour.id)}" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored">Absagen</a>
        </div>
    </g:form>

<script>

    $(document).ready(function() {

        $('#repeat').change(function () {

            var repeatUntil = $("#repeat-until");
            var byInterval = $("#by-interval");

            if($('#repeat').prop("checked")) {
                byInterval.css("display", "inline");
                repeatUntil.css("display", "inline");
            } else {
                byInterval.css("display", "none");
                repeatUntil.css("display", "none");
            }
        });

        var startDate = $('#startDate');
        var endDate = $('#endDate');

        startDate.change(function () {
            var x = startDate.datepicker("getDate");
            console.log("Direct val: " + x);
        });

        startDate.datepicker({
            dateFormat: "dd.mm.yy",
            onSelect: function () {
                var date = startDate.datepicker("getDate");
                $("#startDateVal").val(date.getTime());
                Materialize.updateTextFields();
            }
        });

        endDate.datepicker({
            dateFormat: "dd.mm.yy",
            onSelect: function () {
                var date = endDate.datepicker("getDate");
                $("#endDateVal").val(date.getTime());
                Materialize.updateTextFields();
            }
        });

        $('select').material_select();

        $('ul.tabs').tabs();

        $('.timepicker').pickatime({
            autoclose: true,
            twelvehour: false
        });

    })
</script>

</body>
</html>
