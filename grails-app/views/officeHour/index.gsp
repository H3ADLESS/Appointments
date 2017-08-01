<%@ page import="appointments.DateUtils; appointments.ArrangementType; appointments.Department; appointments.Lecturer" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}" />
    <title>${entityName} - Einstellungen</title>
</head>
<body>

<main>

    <g:render template="/layouts/profileInactiveMessage"/>
    <g:render template="/layouts/message"/>

    <div class="mdl-grid">

        <div class="mdl-cell mdl-cell--12-col">

            <div class="custom-input-container">
                <label class="mdl-textfield__label" for="dateFilter">Datum</label>
                <input class="mdl-textfield__input dateFilter" type="text" id="dateFilter" style="float: left; width: 85%">

                <span style="float: left; cursor: pointer" onclick="clearDateFilter();">
                    <div id="deleteFilter" class="close material-icons" style="font-size: 18px; padding-top: 2px; color: grey">close</div>
                    <div class="mdl-tooltip mdl-tooltip--large" for="deleteFilter">
                        Filter löschen
                    </div>
                </span>

                <input id="dateFilterVal" name="dateFilterVal" value="${params.dateFilter}" style="display:none;">
            </div>

            <g:if test="${manageableLecturers.size() > 1}">
                <g:dropdown callback="filter()" id="lecturer-filter" name="Dozenten filtern" options="${manageableLecturers.sort{it.lastName}}" nameField="name" selected="${Lecturer.findById(params.lecturerFilter)}"/>
            </g:if>

            <div style="float: left; margin-left: 2em; padding-top: 24px;">
                <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="hide-past-appointments" style="float: left">
                    <input type="checkbox" id="hide-past-appointments" class="mdl-checkbox__input" ${params.hidePastAppointments == "true" ? 'checked="checked"' : ''}>
                    <span class="mdl-checkbox__label">Vergangene ausblenden</span>
                </label>
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col" style="overflow-x: auto;">
            <table class="mdl-data-table mdl-js-data-table">
                <thead>
                <tr>
                    <g:sortableColumn property="start" title="Datum" action="index" class="mdl-data-table__cell--non-numeric"/>
                    <th class="mdl-data-table__cell--non-numeric">Professor</th>
                    <th class="mdl-data-table__cell--non-numeric">Thema</th>
                    <th class="mdl-data-table__cell--non-numeric" data-field="start">Beginn</th>
                    <th class="mdl-data-table__cell--non-numeric" data-field="end">Ende</th>
                    <th class="mdl-data-table__cell--non-numeric"></th>
                    <th class="mdl-data-table__cell--non-numeric"></th>
                    <th class="mdl-data-table__cell--non-numeric"></th>
                </tr>
                </thead>

                <tbody>
                <g:each in="${this.officeHourList}">
                    <tr class="${appointments.DateUtils.sameDay(it.start, new Date())? 'today' : ''}">
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:formatDate date="${it.start}" formatName="default.date.format.date" /> ${appointments.DateUtils.sameDay(it.start, new Date())? '(heute)' : ''}
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            ${it.lecturer.name}
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            ${it.publicTitle}
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:formatDate date="${it.start}" formatName="default.date.format.time" />
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:formatDate date="${it.end}" formatName="default.date.format.time" />
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:link action="show" id="${it.id}"><i class="material-icons color-green">search</i></g:link>
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:link action="edit" id="${it.id}"><i class="material-icons color-green">edit</i></g:link>
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:link action="delete" id="${it.id}" params="['dateFilter' : params.dateFilter, 'lecturerFilter' : params.lecturerFilter, 'hidePastAppointments': params.hidePastAppointments]"><i class="material-icons color-green">delete</i></g:link>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <ul class="pagination">
                <g:materializePaginate total="${officeHourCount}" params="['dateFilter' : params.dateFilter, 'lecturerFilter' : params.lecturerFilter, 'hidePastAppointments': params.hidePastAppointments]" />
            </ul>
        </div>

    </div>

    <script>
        $(document).ready(function() {

            var dateFilter = $("#dateFilter");
            dateFilter.datepicker({
                dateFormat: "dd.mm.yy",
                onSelect: function () {
                    var date = dateFilter.datepicker("getDate");
                    $("#dateFilterVal").val(date.getTime());
                    filter();
                }
            });

            if ("${params.dateFilter}" !== "") {
                dateFilter.datepicker("setDate", new Date(${params.dateFilter}));
            }

            $("#hide-past-appointments").on('change', function () {
                filter();
            })

        });

        function getSelectedLecturer(){
            var lecturerId = 0;
            var filterOptions = $("#lecturer-filter").children(".dropdown-options-container").children(".dropdown-option");
            var selectedOption = filterOptions.filter(".selected");
            if (selectedOption !== undefined) {
                lecturerId = selectedOption.data("id");
            }
            return lecturerId
        }

        function filter() {
            console.log("FILTER!");
            var lecturerId = getSelectedLecturer();
            var hidePastAppointments = $("#hide-past-appointments").prop("checked");
            location.href = "${createLink(action: "index")}" + "?dateFilter=" + $("#dateFilterVal").val() + "&lecturerFilter=" + lecturerId + '&hidePastAppointments=' + hidePastAppointments;
        }

        function clearDateFilter() {
            var lecturerId = getSelectedLecturer();
            location.href = "${createLink(action: "index")}" + "?lecturerFilter=" + lecturerId;
        }

    </script>

</main>

</body>

