<%@ page import="appointments.Appointment" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>

    <asset:stylesheet src="timeline.css"/>

    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'OfficeHour')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>

<body>

<div class="mdl-grid">
    <div class="mdl-cell mdl-cell--12-col">
        <h4>Sprechstunde am <g:formatDate formatName="default.date.format.date" date="${this.officeHour?.start}"/></h4>
        Von <g:formatDate formatName="default.date.format.time" date="${this.officeHour?.start}"/> bis <g:formatDate formatName="default.date.format.time" date="${this.officeHour?.end}"/> Uhr
    </div>

    <g:set var="seriesCount" value="${this.officeHour?.officeHourGroup?.officeHours?.size()}"/>
    <g:if test="${seriesCount > 1}">
        <div class="mdl-cell mdl-cell--12-col">
            <div class="col s12">
                Diese Sprechstunde ist Teil einer Serie mit ${seriesCount} Terminen. <a href="${createLink(controller: 'officeHourGroup', action: 'show', id: this.officeHour.officeHourGroup.id)}">Alle Termine dieser Serie ansehen.</a>
            </div>
        </div>
    </g:if>
</div>

<div class="mdl-grid">


<div class="mdl-cell mdl-cell--12-col">
    <g:if test="${officeHours?.size() > 0}">
        <g:each in="${officeHours}" var="oH">
            <g:if test="${oH.publicTitle}">
                <h5>${oH.publicTitle} - Termine am <g:formatDate date="${officeHours?.first()?.date}" formatName="default.date.format.date"/> </h5>
            </g:if>
            <g:else>
                <h5>Termine am <g:formatDate date="${officeHours?.first()?.date}" formatName="default.date.format.date"/> </h5>
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
                                    <div class="timeline" style="float: left; width: 2em;">
                                        <div class="line" style="height: ${slot.rowspan * rowspanFactor + 1}em"></div>
                                    </div>
                                    <div class="info own" style="height: ${slot.rowspan * rowspanFactor + 0.5}em;" onclick="window.location='${createLink(controller: 'appointment', action: 'show', id: appointment.id)}'">
                                        ${appointment.firstName} ${appointment.lastName} - ${appointment.subject} <span style="float: right"> <i class="material-icons">search</i> </span>
                                    </div>
                                </div>
                            </g:if>
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

                        <div class="timeline-row free" date="${slot.date}" officeHourId="${slot.officeHourId}">
                            <div class="time">

                            </div>
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
        $('#appointment-dialog').show("slide", {direction: "down"}, "slow");

        $("#dialogNextStep").off();
        $("#dialogNextStep").on('click', function () {
            var officeHour = $(firstSelection).attr("officeHourId");
            var date = $(firstSelection).attr("date");
            console.log(date + " // " + officeHour);
            window.location = "${createLink(controller: 'appointment', action: 'create')}" + "?officeHour=" + officeHour + "&date=" + date + "&duration=" + time;
        });

        $("#dialogCancel").off();
        $("#dialogCancel").on('click', function () {
            resetSelectionAndText();
        });
    }

    function hideDialog() {
        $('#appointment-dialog').hide("slide", {direction: "down"}, "slow");
    }

    function orderSelections(){
        if (firstSelection.index() > secondSelection.index()) {
            var tmp = secondSelection;
            secondSelection = firstSelection;
            firstSelection = tmp;
        }
    }

    function showPossibleSecondSelections(){
        $(".info.free").text(" ");
        $(firstSelection).children(".info").text("Beginn");
        var prev = $(firstSelection).prevUntil(".timeline-row.blocked", ".timeline-row.free").children(".info");
        prev.text("Als Ende festlegen");
        var next = $(firstSelection).nextUntil(".timeline-row.blocked", ".timeline-row.free").children(".info");
        next.text("Als Ende festlegen");
    }

    function resetPossibleSecondSelection() {
        $(".timeline-row.free").children(".info").text("${message(code: 'appointment.index.selectAsStart')}");
    }

    function highlightSelectionAndUpdateText(selection){
        resetPossibleSecondSelection();
        var freeTimelineRows = $(selection).filter(".timeline-row.free");
        freeTimelineRows.children(".info.free").text(" ");
        var time = ($(freeTimelineRows).length) * 5;
        $(firstSelection).children(".info").html(time + " Minuten ausgewählt");
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
                    orderSelections();

                    all = $(firstSelection).nextUntil($(secondSelection));
                    all = all.add(firstSelection);
                    all = all.add(secondSelection);
                }

                if (checkIfSelectionIsBlocked(all)){
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
    });

</script>