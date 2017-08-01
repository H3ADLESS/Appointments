<%@ page import="org.springframework.validation.FieldError; java.time.LocalTime; java.time.LocalDate; appointments.Department; appointments.Lecturer" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>

    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'OfficeHour')}" />
    <title><g:message code="default.create.label" args="[entityName]" /></title>

</head>
<body>

<main>

    <div class="mdl-grid">
        <div class="mdl-cell mdl-cell--12-col">

            <g:render template="/layouts/profileInactiveMessage"/>
            <g:render template="/layouts/message"/>

            <h4><g:message code="default.create.label" args="[entityName]" /></h4>
            Hier können Sie eine einzelne oder auch regelmäßig wiederkehrende Sprechstunde anlegen.

            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.officeHour}">
                <ul class="errors" role="alert">
                    <g:eachError bean="${this.officeHour}" var="error">
                        <li <g:if test="${error in FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
                </ul>
            </g:hasErrors>
        </div>

            <g:form bean="officeHour" action="save" method="post">
                <div class="mdl-cell mdl-cell--12-col">

                    <g:if test="${assistantOf.size() > 0}">
                        <b>Für wen möchten Sie den Termin anlegen?</b>
                        <div class="row">
                            <div class="input-field col s12">
                                <select id="lecturer" name="lecturer">
                                    <g:if test="${currentUser instanceof Lecturer}">
                                        <option value="${currentUser?.id}" ${currentUser.id.toString() == params.lecturer? "selected" : ""}>mich</option>
                                    </g:if>
                                    <g:each in="${assistantOf}">
                                        <option value="${it.id}" ${it.id.toString() == params.lecturer? "selected" : ""}>${it.name}</option>
                                    </g:each>
                                </select>
                            </div>
                        </div>
                    </g:if>
                    <g:else>
                        <div class="row" style="display: none">
                            <div class="input-field col s12">
                                <select id="lecturer" name="lecturer">
                                    <option value="${currentUser?.id}" selected>mich</option>
                                </select>
                            </div>
                        </div>
                    </g:else>
                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <b>Öffentlicher Titel und Beschreibung der Sprechstunde</b><br>
                    <p>Geben Sie einen Titel und/oder eine Beschreibung ein. Sie können das Feld für zusätzliche
                    Informationen nutzen. Zum Beispiel für wen die Sprechstunde gedacht ist. </p>

                    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                        <input class="mdl-textfield__input" type="text" id="title" name="title">
                        <label class="mdl-textfield__label" for="title">Titel</label>
                    </div> <br>

                    <div class="mdl-textfield mdl-js-textfield">
                        <textarea class="mdl-textfield__input" type="text" rows= "3" id="description" name="description" ></textarea>
                        <label class="mdl-textfield__label" for="description">Beschreibung</label>
                    </div>


                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <b>Datum und Zeit der Sprechstunde</b> <br>

                    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label date">
                        <input class="mdl-textfield__input datepicker-start" type="text" id="startDate" name="startDate">
                        <label class="mdl-textfield__label" for="description">Termin*</label>
                    </div>

                    <input id="startDateVal" name="startDateVal" value="" style="display:none;">

                    <br>

                    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-dirty time">
                        <input class="mdl-textfield__input" type="time" id="startTime" name="startTime">
                        <label class="mdl-textfield__label" for="title">Beginn*</label>
                    </div>

                    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-dirty time">
                        <input class="mdl-textfield__input" type="time" id="endTime" name="endTime">
                        <label class="mdl-textfield__label" for="title">Ende*</label>
                    </div>

                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <b>Buchungs-Deadline</b>
                    <div class="row">
                        <div class="col s12">
                            Buchbar bis
                            <div style="width: 3em" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-dirty time">
                                <input class="mdl-textfield__input" id="relativeDeadline" name="relativeDeadline" type="number" min="0" placeholder="0">
                            </div>
                            Stunde(n) vor der Sprechstunde
                        </div>
                    </div>
                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <b>Zeitlimits</b>
                    <div class="row">
                        <div class="col s12">
                            Ein Termin in der Sprechstunde darf maximal
                            <div style="width: 3em" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-dirty time">
                                <input class="mdl-textfield__input" id="maxDurationInMinutes" name="maxDurationInMinutes" type="number" min="0" step="5" placeholder="0">
                            </div>
                            Minuten dauern. (Der Wert 0 deaktiviert das Limit).
                        </div>
                    </div>
                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <b>Termin regelmäßig wiederholen</b> <br>
                    <div class="col s12" style="padding-top: 1em;">

                        <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="repeat">
                            <input type="checkbox" id="repeat" name="repeat" class="mdl-checkbox__input">
                            <span class="mdl-checkbox__label">Termin wiederholen?</span>
                        </label>

                    </div>
                </div>

                <div class="mdl-cell mdl-cell--12-col">
                    <div id="by-interval" style="display: none">
                        <div class="row">
                            <div class="col s12">
                                Sprechstunde alle
                                <div style="width: 3em" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-dirty">
                                    <input class="mdl-textfield__input" id="repeatByDayInterval" name="repeatByDayInterval" type="number" min="1" placeholder="z.B. 7" value="${repeatByDayInterval ? repeatByDayInterval:""}">
                                </div>
                                Tage wiederholen*
                            </div>
                        </div>
                    </div>
                </div>

            <div class="mdl-cell mdl-cell--12-col">
                <div id="repeat-until" style="display: none">
                    <div class="row">
                        <div class="input-field col s12">
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label is-dirty">
                                <input class="mdl-textfield__input datepicker-endDate" id="endDate" name="endDate" type="text" value="">
                                <input id="endDateVal" name="endDateVal" value="" style="display: none">
                                <label class="mdl-textfield__label" for="title">Letzter Termin*</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mdl-cell mdl-cell--12-col" style="padding-top: 1em;">
                <input type="submit" name="create" class="mdl-button mdl-js-button mdl-button--colored mdl-button--raised" value="Anlegen" id="create">
            </div>
        </g:form>
    </div>

</main>

<script>
    $(document).ready(function() {

        $('#maxDurationInMinutes').on('change', function () {
            console.log("call");
            var value = $(this).val();
            var newValue = Math.ceil(value/5)*5;
            $(this).val(newValue)
        });

        $('.time').addClass("is-dirty");

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
                $(startDate).parent().addClass("is-dirty");
            }
        });

        endDate.datepicker({
            dateFormat: "dd.mm.yy",
            onSelect: function () {
                var date = endDate.datepicker("getDate");
                $("#endDateVal").val(date.getTime());
                $(endDate).parent().addClass("is-dirty");
            }
        });

        $('.timepicker').pickatime({
            autoclose: true,
            twelvehour: false
        });
    })
</script>

</body>





