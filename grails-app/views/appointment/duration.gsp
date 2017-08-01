<%@ page import="appointments.Appointment; appointments.User" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>

    <asset:stylesheet src="timeline.css"/>

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

                <div class="step done">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">2</div>
                    </div>
                    <div class="stepper-text">
                        Startzeitpunkt des Termins wählen
                        %{--<a href="${createLink(controller: 'appointment', action: 'index', id: lecturer.id)}">Startzeitpunkt des Termins wählen</a>--}%
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="step active">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">3</div>
                    </div>
                    <div class="stepper-text">
                        Dauer festlegen
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="step">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">4</div>
                    </div>
                    <div class="stepper-text">
                        Eckdaten mitteilen
                    </div>
                </div>

            </div>
        </div>

        <div class="mdl-cell mdl-cell--8-col">
            <h4>Einen Termin bei ${lecturer?.title} ${lecturer?.firstName} ${lecturer?.lastName} vereinbaren</h4>
            <p>Wähle die Dauer / das Ende deines Termins aus.</p>
        </div>

        %{--TODO: anzeigen oder nicht?--}%
        %{--<div class="mdl-cell mdl-cell--4-col">--}%
            %{--<div id="calendar"></div>--}%
        %{--</div>--}%

        <div class="mdl-cell mdl-cell--12-col">
            <g:if test="${officeHours?.size() > 0}">
                <g:each in="${officeHours}" var="oH">
                    <g:if test="${oH.publicTitle}">
                        <h5>${oH.publicTitle} - Termine am <g:formatDate date="${officeHours?.first()?.date}" formatName="default.date.format.date"/> <input type="button" class="btn hide-on-large-only small-datepicker" value="Datum ändern"/></h5>
                    </g:if>
                    <g:else>
                        <h5>Termine am <g:formatDate date="${officeHours?.first()?.date}" formatName="default.date.format.date"/> <input type="button" class="btn hide-on-large-only small-datepicker" value="Datum ändern"/></h5>
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

                                %{-- Termin ist NICHT vom angemeldeten Nutzer --}%
                                %{--<g:else>--}%
                                    <g:if test="${slot.first}">
                                        <div class="timeline-row ${slot?.afterSelectedSlot? 'selected' : ''}">
                                            <div class="time">
                                                ${(slot.startHour < 10) ? "0${slot.startHour}" : "${slot.startHour}"}:${(slot.startMinute < 10) ? "0${slot.startMinute}" : "${slot.startMinute}"}
                                            </div>
                                            <div class="timeline dot-container" style="float: left; width: 2em; ">
                                                <div class="dot"></div>
                                            </div>
                                        </div>

                                        <div class="timeline-row" style="height: ${slot.rowspan * rowspanFactor}em;">
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
                                %{--</g:else>--}%
                            </g:if>
                            %{-- Termin ist frei: --}%
                            <g:else>

                                <div class="timeline-row ${slot?.selectedSlot? 'selected' : ''} ${slot?.afterSelectedSlot? 'selected' : ''}">
                                    <div class="time">
                                        ${(slot.startHour < 10) ? "0${slot.startHour}" : "${slot.startHour}"}:${(slot.startMinute < 10) ? "0${slot.startMinute}" : "${slot.startMinute}"}
                                    </div>
                                    <div class="timeline dot-container" style="float: left; width: 2em; ">
                                        <div class="dot"></div>
                                    </div>
                                </div>

                                <div class="timeline-row free ${slot?.selectedSlot? 'selected' : ''}" date="${slot.date}" officeHourId="${slot.officeHourId}">
                                    <div class="time">

                                    </div>
                                    %{--height: ${slot.rowspan * rowspanFactor}em--}%
                                    <div class="timeline" style="float: left; width: 2em; ">
                                        <div class="line" style="height: ${slot.rowspan * rowspanFactor + 1}em"></div>
                                    </div>
                                    <div class="info free" style="height: ${rowspanFactor + 0.5}em;">
                                        <g:if test="${slot?.selectedSlot}">
                                            Dein Termin
                                        </g:if>
                                        <g:else>
                                            Dauer festlegen
                                        </g:else>
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

    <script>

        function initSlots() {
            $(".timeline-row.selected").nextAll('.timeline-row').hover(
                function () {
                    // handler In
                    var target = $('.timeline-row:hover').next($('.timeline-row:has(.info)')).next();

                    if (target.children(".dot-container").length === 1){
                        target = target.prev()
                    }

                    $(".timeline-row.selected").nextUntil(target).addClass("jsSelected");

                    $(".timeline-row.selected .info").html("Dein Termin - " + $(".jsSelected:has(.info)").length * 5 + " Minuten.");
                },
                function () {
                    // handler Out
                    $(".timeline-row.selected").nextAll('.timeline-row').removeClass("jsSelected");
                }
            );

            $(".timeline-row.free").click( function () {
                var date = $(".timeline-row.free.selected").attr("date");
                var officeHour = $(".timeline-row.free.selected").attr("officeHourId");
                console.log(date + " // " + officeHour);
                $(".jsSelected:has(.info)").length
                window.location = "${createLink(action: 'create')}" + "?officeHour=" + officeHour + "&date=" + date + "&duration=" + $(".jsSelected:has(.info)").length * 5;
            })
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


</main>


</body>
</html>