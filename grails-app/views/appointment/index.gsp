<%@ page import="appointments.Appointment; appointments.User" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>

    <asset:stylesheet src="timeline.css"/>
    <asset:javascript src="timeline.js"/>
    %{--<asset:javascript src="jquery-ui.min.js"/>--}%
    %{--<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.min.js" integrity="sha256-eGE6blurk5sHj+rmkfsGYeKyZx3M4bG+ZlFyA7Kns7E=" crossorigin="anonymous"></script>--}%

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
                        Termin wählen
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="step">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">3</div>
                    </div>
                    <div class="stepper-text">
                        Eckdaten mitteilen
                    </div>
                </div>

            </div>
        </div>

        <div class="mdl-cell mdl-cell--8-col">
            <h4>Einen Termin bei ${lecturer?.title} ${lecturer?.firstName} ${lecturer?.lastName} vereinbaren</h4>
            <h6>Wähle Beginn und Ende deines Termins.</h6>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <g:if test="${officeHours?.size() > 0}">
                <g:each in="${officeHours}" var="oH">
                    <g:if test="${oH.publicTitle}">
                        <h5>
                            <g:if test="${prevOhDate != null}">
                                <button class="mdl-button mdl-js-button mdl-button--icon" onclick="window.location='${createLink(action: 'index', id: lecturer.id, params:['date': prevOhDate])}'">
                                    <i class="material-icons">navigate_before</i>
                                </button>
                            </g:if>

                            ${oH.publicTitle} - Termine am <g:formatDate date="${officeHours?.first()?.date}" formatName="default.date.format.date"/>

                            <input type="button" style="margin-left: 0.8em; position: relative; z-index: 950;" class="mdl-button mdl-js-button small-datepicker mdl-button--raised" value="Datum ändern"/>

                            <g:if test="${nextOhDate != null}">
                                <button class="mdl-button mdl-js-button mdl-button--icon" onclick="window.location='${createLink(action: 'index', id: lecturer.id, params:[date: nextOhDate])}'">
                                    <i class="material-icons md-48">navigate_next</i>
                                </button>
                            </g:if>
                        </h5>
                    </g:if>
                    <g:else>
                        <h5>Termine am <g:formatDate date="${officeHours?.first()?.date}" formatName="default.date.format.date"/>
                            <input type="button" style="margin-left: 0.8em; position: relative; z-index: 950" class="mdl-button mdl-js-button small-datepicker mdl-button--raised" value="Datum ändern"/>
                        </h5>
                    </g:else>
                    <g:if test="${oH.publicDescription}">
                        <p>${oH.publicDescription}</p>
                    </g:if>

                    <g:set var="rowspanFactor" value="${1.5}"/>

                    <div class="timeline-container">

                        <g:each var="slot" in="${oH.slots}">

                            %{-- Termin ist blockiert --}%
                            <g:if test="${slot.blocked}">
                                <g:set var="appointment" value="${Appointment.findById(slot.appointmentId)}"/>

                                %{-- Termin ist vom angemeldeten Nutzer: --}%
                                <g:if test="${appointment?.user == user}">
                                    %{--<tr class="blocked ${slot.even ? "even" : "odd"} ${slot.first ? "first" : ""} own ${slot.rowspan}" onclick="window.location='${createLink(controller: 'appointment', action: 'show', id: appointment.id)}'">--}%
                                        <g:if test="${slot.first}">
                                            <div class="timeline-row">
                                                <div class="time">
                                                    ${(slot.startHour < 10) ? "0${slot.startHour}" : "${slot.startHour}"}:${(slot.startMinute < 10) ? "0${slot.startMinute}" : "${slot.startMinute}"}
                                                </div>
                                                <div class="timeline dot-container" style="float: left; width: 2em; ">
                                                    <div class="dot"></div>
                                                </div>
                                            </div>

                                            <div class="timeline-row blocked" style="height: ${slot.rowspan * rowspanFactor}em;">
                                                <div class="time">

                                                </div>
                                                %{--height: ${slot.rowspan * rowspanFactor}em--}%
                                                <div class="timeline" style="float: left; width: 2em;">
                                                    <div class="line" style="height: ${slot.rowspan * rowspanFactor + 1}em"></div>
                                                </div>
                                                <div class="info own" style="height: ${slot.rowspan * rowspanFactor + 0.5}em;" onclick="window.location='${createLink(controller: 'appointment', action: 'show', id: appointment.id)}'">
                                                    Ihr Termin: ${appointment.subject} <span style="float: right"> <i class="material-icons">search</i> </span>
                                                </div>
                                            </div>
                                        </g:if>
                                </g:if>

                                %{-- Termin ist NICHT vom angemeldeten Nutzer --}%
                                <g:else>
                                    <g:if test="${slot.first}">
                                        <div class="timeline-row">
                                            <div class="time">
                                                ${(slot.startHour < 10) ? "0${slot.startHour}" : "${slot.startHour}"}:${(slot.startMinute < 10) ? "0${slot.startMinute}" : "${slot.startMinute}"}
                                            </div>
                                            <div class="timeline dot-container" style="float: left; width: 2em; ">
                                                <div class="dot"></div>
                                            </div>
                                        </div>

                                        <div class="timeline-row blocked" style="height: ${slot.rowspan * rowspanFactor}em;">
                                            <div class="time">

                                            </div>
                                            %{--height: ${slot.rowspan * rowspanFactor}em--}%
                                            <div class="timeline" style="float: left; width: 2em;">
                                                <div class="line" style="height: ${slot.rowspan * rowspanFactor + 1}em"></div>
                                            </div>
                                            <div class="info blocked" style="height: ${slot.rowspan * rowspanFactor}em;">
                                                Belegt
                                            </div>
                                        </div>
                                    </g:if>
                                </g:else>
                            </g:if>
                            %{-- Termin ist frei: --}%
                            <g:else>

                                <div class="timeline-row">
                                    <div class="time">
                                        ${(slot.startHour < 10) ? "0${slot.startHour}" : "${slot.startHour}"}:${(slot.startMinute < 10) ? "0${slot.startMinute}" : "${slot.startMinute}"}
                                    </div>
                                    <div class="timeline dot-container" style="float: left; width: 2em; ">
                                        <div class="dot"></div>
                                    </div>
                                </div>

                                <div class="timeline-row free" date="${slot.date}" officeHourId="${slot.officeHourId}" maxDuration="${oH.maxDuration}">
                                    <div class="time">

                                    </div>
                                    %{--height: ${slot.rowspan * rowspanFactor}em--}%
                                    <div class="timeline" style="float: left; width: 2em; ">
                                        <div class="line" style="height: ${slot.rowspan * rowspanFactor + 1}em"></div>
                                    </div>
                                    <div class="info free" style="height: ${rowspanFactor + 0.5}em;">
                                        <g:message code="appointment.index.selectAsStart"/> <span style="float: right"> <i class="material-icons">edit</i> </span>
                                    </div>
                                </div>

                            </g:else>
                        </g:each>

                        <div class="timeline-row">
                            <div class="time">
                                ${(oH.endHour < 10) ? "0${oH.endHour}" : "${oH.endHour}"}:${(oH.endMinute < 10) ? "0${oH.endMinute}" : "${oH.endMinute}"}
                            </div>
                            <div class="timeline dot-container" style="float: left; width: 2em; ">
                                <div class="dot"></div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </g:if>
            <g:else>
                Keine Sprechstunde verfügbar.
            </g:else>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <div style="max-width: 72em; width: 70%;">
                <g:if test="${prevOhDate != null}">
                    <div style="float: left">
                    <button class="mdl-button mdl-js-button" onclick="window.location='${createLink(action: 'index', id: lecturer.id, params:['date': prevOhDate])}'">
                        <i class="material-icons">navigate_before</i> Vorige Sprechstunde
                    </button>

                    </div>
                </g:if>

                <g:if test="${nextOhDate != null}">
                    <div style="float: right">

                        <button class="mdl-button mdl-js-button" onclick="window.location='${createLink(action: 'index', id: lecturer.id, params:[date: nextOhDate])}'">
                            Nächste Sprechstunde <i class="material-icons md-48">navigate_next</i>
                        </button>
                    </div>
                </g:if>
            </div>
        </div>

    </div>

</main>

<div id="appointment-dialog">
    <h6 style="margin: 0">Zeitraum bestätigen</h6>
    <div style="float: right">
        <button id="dialogCancel" class="mdl-button mdl-js-button" style="color: white"> Abbrechen </button>
        <button id="dialogNextStep" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" style=""> Weiter </button>
    </div>
</div>

<script>

    function showDialog(time){
        var tmpFirst = firstSelection;
        if (firstSelection.index() > secondSelection.index()) {
            tmpFirst = secondSelection;
        }

        $('#appointment-dialog').show("slide", {direction: "down"}, "slow");

        $("#dialogNextStep").off();
        $("#dialogNextStep").on('click', function () {
            var officeHour = $(tmpFirst).attr("officeHourId");
            var date = $(tmpFirst).attr("date");
            console.log(date + " // " + officeHour);
            window.location = "${createLink(action: 'create')}" + "?officeHour=" + officeHour + "&date=" + date + "&duration=" + time;
        });

        $("#dialogCancel").off();
        $("#dialogCancel").on('click', function () {
            resetSelectionAndText();
        });
    }

    function hideDialog() {
        $('#appointment-dialog').hide("slide", {direction: "down"}, "slow");
    }

    function getSelection(){
        var tmpFirst = firstSelection;
        var tmpSecond = secondSelection;
        if (firstSelection.index() > secondSelection.index()) {
            tmpFirst = secondSelection;
            tmpSecond = firstSelection;
        }

        var all = $(tmpFirst).nextUntil($(tmpSecond));
        all = all.add(firstSelection);
        all = all.add(secondSelection);
        return all;
    }

//    function sortSelections(){
//        if (firstSelection.index() > secondSelection.index()) {
//            var tmp = secondSelection;
//            secondSelection = firstSelection;
//            firstSelection = tmp;
//        }
//    }

    function showPossibleSecondSelections(){
        $(".info.free").text(" ");
        $(firstSelection).children(".info").text("Beginn");
        var maxDuration = $(firstSelection).attr("maxduration");

        if (maxDuration != 0) {
            var duration = (maxDuration / 5) - 1;
            var prev = $(firstSelection).prevUntil(".timeline-row.blocked", ".timeline-row.free:lt(" + duration + ")").children(".info");
            prev.text("Als Ende festlegen");
            prev.last().append("<div style='float: right; margin-right: 1em;'>(Max. " + maxDuration + " Minuten)</div>");
            var next = $(firstSelection).nextUntil(".timeline-row.blocked", ".timeline-row.free:lt(" + duration + ")").children(".info");
            next.text("Als Ende festlegen");
            next.last().append("<div style='float: right; margin-right: 1em;'>(Max. " + maxDuration + " Minuten)</div>");
        } else {
            var prev = $(firstSelection).prevUntil(".timeline-row.blocked", ".timeline-row.free").children(".info");
            prev.text("Als Ende festlegen");
            var next = $(firstSelection).nextUntil(".timeline-row.blocked", ".timeline-row.free").children(".info");
            next.text("Als Ende festlegen");
        }
    }

    function resetPossibleSecondSelection() {
        $(".timeline-row.free").children(".info").text("${message(code: 'appointment.index.selectAsStart')}");
    }

    function checkIfMaximumDurationIsExceeded(selection) {
        var maxDuration = $(firstSelection).attr("maxduration");
        if (maxDuration == 0) return false;
        var freeTimelineRows = $(selection).filter(".timeline-row.free");
        var time = ($(freeTimelineRows).length) * 5;
        if (time > maxDuration) {
            return true
        } else {
            return false
        }
    }

    function highlightSelectionAndUpdateText(selection){
        resetPossibleSecondSelection();
        var freeTimelineRows = $(selection).filter(".timeline-row.free");
        freeTimelineRows.children(".info.free").text(" ");
        var time = ($(freeTimelineRows).length) * 5;

        if (firstSelection.index() > secondSelection.index()) {
            $(secondSelection).children(".info").html(time + " Minuten ausgewählt");
        } else {
            $(firstSelection).children(".info").html(time + " Minuten ausgewählt");
        }
        showDialog(time);

        $(freeTimelineRows).addClass("jsSelected");

        var dots = selection.filter(".timeline-row:has(.timeline.dot-container)");
        dots.hide();
    }

    function resetSelectionAndText() {
        hideDialog();
        var editedElements = $(".jsSelected");
        editedElements.removeClass("jsSelected");
        editedElements.children(".info").text("${message(code: 'appointment.index.selectAsStart')}");
        $(".timeline-row:has(.timeline.dot-container):hidden").show();
        firstSelection = undefined;
        secondSelection = undefined;
    }

    function checkIfSelectionIsBlocked(selection) {
        return ($(selection).filter(".timeline-row.blocked").length > 0);
    }

    var firstSelection;
    var secondSelection;

    function initSlots(){
        $(".timeline-row.free").on('click', function () {
            console.log("hey");
            if (firstSelection === undefined) {
                $(this).addClass("jsSelected");
                firstSelection = $(this);
                showPossibleSecondSelections();
            } else if ( firstSelection !== undefined && secondSelection !== undefined){
                resetSelectionAndText();

                $(this).addClass("jsSelected");
                firstSelection = $(this);
                secondSelection = undefined;
                showPossibleSecondSelections();
            } else {
                secondSelection = $(this);

                var all;
                if ($(firstSelection).is($(secondSelection))) {
                    all = $(firstSelection);
                } else {
                    all = getSelection();
                }

                if (checkIfMaximumDurationIsExceeded(all)){
                    console.log("T O   L O N G");
                    secondSelection = undefined;
                } else if (checkIfSelectionIsBlocked(all)){
                    console.log("B L O C K E D");
                    secondSelection = undefined;
                } else {
                    highlightSelectionAndUpdateText(all);
                }
            }
        });
    }

    $(document).ready(function() {

        initSlots();

        var date = $('#date');

        date.datepicker({
            dateFormat: "dd.mm.yy",
            onSelect: function () {
                var date = date.datepicker("getDate");
                $("#dateVal").val(date.getTime());
                Materialize.updateTextFields();
            }
        });

        var officeHourDates = [
            ${dates ? dates.join(",") : ""}
        ];

        console.log(officeHourDates);

        var calendar = $("#calendar");
        $( function() {
            calendar.datepicker({
                defaultDate: new Date(${officeHours?.get(0)?.date ? officeHours?.get(0)?.date.getTime() : new Date().getTime()}),
                regional: "de",
                onSelect: function (dateText, inst) {
                    var d = calendar.datepicker("getDate");
                    console.log(d);
                    window.location = ("${createLink(controller: 'appointment', action: 'index', id: lecturer.id)}" + "?date=" + d.getTime());
                },
                beforeShowDay: function (date) {
                    if($.inArray(date.getTime(), officeHourDates) > -1) {
                        return [true, "available", ""];
                    } else {
                        return [false, "not", ""];
                    }
                }
            });
        });

        var calendar2 = $(".small-datepicker");
        $( function() {
            calendar2.datepicker({
                defaultDate: new Date(${officeHours?.get(0)?.date ? officeHours?.get(0)?.date.getTime() : new Date().getTime()}),
                regional: "de",
                dateFormat: "dd.mm.yyyy",
                onSelect: function (dateText, inst) {
                    var d = calendar2.datepicker("getDate");
                    console.log(d);
                    window.location = ("${createLink(action: 'index', id: lecturer.id)}" + "?date=" + d.getTime());
                },
                beforeShowDay: function (date) {
                    if($.inArray(date.getTime(), officeHourDates) > -1) {
                        return [true, "available", ""];
                    } else {
                        return [false, "not", ""];
                    }
                }
            });
        });

    });
</script>

</body>
</html>