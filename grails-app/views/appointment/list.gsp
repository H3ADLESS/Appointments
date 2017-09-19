%{--list users appointments--}%

<%@ page import="appointments.DateUtils; appointments.User; appointments.Department; appointments.Lecturer" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}"/>

    <title><g:message code="myAppointments.title" default="My Appointments"/> </title>
</head>

<body>


<div class="mdl-grid">
    <div class="mdl-cell mdl-cell--12-col">
        <h4>Deine Termine</h4>
        <p>Nachfolgend finden Sie eine Übersicht über Ihre gemachten Termine.</p>
        <g:render template="/layouts/message"/>
    </div>

    <div class="mdl-cell mdl-cell--12-col">
        <div style="float: left; margin-bottom: 0.8em">
            <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="hide-past" style="float: left">
                <input type="checkbox" id="hide-past" class="mdl-checkbox__input" ${params.hidePast == "true" ? 'checked="checked"' : ''}>
                <span class="mdl-checkbox__label">Vergangene ausblenden</span>
            </label>
        </div>
    </div>


    <div class="mdl-cell mdl-cell--12-col" style="overflow-x: auto;">
        <table class="mdl-data-table mdl-js-data-table">
            <thead>
                <tr>
                    <th class="mdl-data-table__cell--non-numeric">Datum</th>
                    <th class="mdl-data-table__cell--non-numeric">Zeit</th>
                    <th class="mdl-data-table__cell--non-numeric">Thema</th>
                    <th class="mdl-data-table__cell--non-numeric">Bei</th>
                    <th class="mdl-data-table__cell--non-numeric"></th>
                    <th class="mdl-data-table__cell--non-numeric"></th>
                    <th class="mdl-data-table__cell--non-numeric"></th>
                </tr>
            </thead>
            <tbody>
                <g:if test="${appointments.size() == 0}">
                    <tr>
                        <td colspan="7" style="text-align: left">
                            Keine Termine
                        </td>
                    </tr>
                </g:if>
                <g:else>
                    <g:each in="${appointments.sort{it.start}}">
                        <tr class="${DateUtils.sameDay(it.start, new Date())? 'today' : ''}">
                            <td class="mdl-data-table__cell--non-numeric">
                                <g:formatDate formatName="default.date.format.date" date="${it.start}"/> ${appointments.DateUtils.sameDay(it.start, new Date())? '(heute)' : ''}
                            </td>
                            <td class="mdl-data-table__cell--non-numeric">
                                <g:formatDate formatName="default.date.format.time" date="${it.start}"/> -
                                <g:formatDate formatName="default.date.format.time" date="${it.end}"/> Uhr
                            </td>
                            <td class="mdl-data-table__cell--non-numeric">
                                ${it.subject}
                            </td>
                            <td class="mdl-data-table__cell--non-numeric">
                                ${it.officeHour.lecturer.name}
                            </td>
                            <td class="mdl-data-table__cell--non-numeric">
                                <g:link action="show" id="${it.id}" style="color: #6c9f21"><i class="material-icons">search</i></g:link>
                            </td>
                            <td class="mdl-data-table__cell--non-numeric">
                                <g:link action="edit" id="${it.id}" style="color: #6c9f21"><i class="material-icons">edit</i></g:link>
                            </td>
                            <td class="mdl-data-table__cell--non-numeric">
                                <g:link action="delete" id="${it.id}" style="color: #6c9f21"><i class="button-red material-icons">delete</i></g:link>
                            </td>
                        </tr>
                    </g:each>
                </g:else>
            </tbody>
        </table>
    </div>
</div>


<script>

    $(document).ready(function () {
        $("#hide-past").on('change', function () {
            window.location = "${createLink(controller: 'appointment', action: 'list')}" + '?hidePast=' + $("#hide-past").prop("checked");
        });
    });


</script>


</body>