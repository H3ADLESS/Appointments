<%@ page import="appointments.OfficeHour; appointments.Department; appointments.Lecturer" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHourGroup.label', default: 'Office Hour')}"/>
    <title>${entityName} - Einstellungen</title>
</head>

<body>

<main>

    <div class="mdl-grid">
        <div class="mdl-cell mdl-cell--12-col">
            <h4>Sprechstunden dieser Gruppe anzeigen</h4>
            Hier finden Sie eine Übersicht über die einzelnen Termine dieser Sprechstunde. Es sind mehrere, wenn
            Sie einen regelmäßigen Termin angelegt haben.

            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

        </div>
        <div class="mdl-cell mdl-cell--12-col">
            ${this.officeHourGroup.name} <br>
            ${this.officeHourGroup.description}

            <table class="mdl-data-table mdl-js-data-table">
                <thead>
                <tr>
                    <th class="mdl-data-table__cell--non-numeric">
                        Datum
                    </th>
                    <th class="mdl-data-table__cell--non-numeric">
                        Start
                    </th>
                    <th class="mdl-data-table__cell--non-numeric">
                        Ende
                    </th>
                    <th class="mdl-data-table__cell--non-numeric">

                    </th>
                    <th class="mdl-data-table__cell--non-numeric">

                    </th>
                    <th class="mdl-data-table__cell--non-numeric">

                    </th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${this.officeHourGroup.officeHours.sort{it.start}}">
                    <tr>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:formatDate date="${it.start}" formatName="default.date.format.date"/>
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:formatDate date="${it.start}" formatName="default.date.format.time"/>
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <g:formatDate date="${it.end}" formatName="default.date.format.time"/>
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <a href="${createLink(controller: 'officeHour', action: 'show', id: it.id)}" class="tooltipped" data-tooltip="Ansehen"> <i class="material-icons green-text">search</i> </a>
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <a href="${createLink(controller: 'officeHour', action: 'edit', id: it.id)}" class="tooltipped" data-tooltip="Bearbeiten oder Verschieben"> <i class="material-icons green-text">mode_edit</i> </a>
                        </td>
                        <td class="mdl-data-table__cell--non-numeric">
                            <a href="${createLink(controller: 'officeHour', action: 'delete', id: it.id)}" class="tooltipped" data-tooltip="Löschen"> <i class="material-icons green-text">delete</i> </a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>

            <div class="mdl-cell mdl-cell--12-col">

                <g:form resource="${this.officeHourGroup}" method="DELETE">

                    <br>

                    <!-- Raised button -->
                    <button class="mdl-button mdl-js-button mdl-button--raised" type="submit" name="action">
                        <i class="material-icons right">delete</i> ${message(code: 'officeHourGroup.button.deleteGroup.label', default: 'Delete All Office Hours')}
                    </button>

                </g:form>

            </div>

        </div>
    </div>

    <script>
        $(document).ready(function () {
            $('.tooltipped').tooltip({delay: 50});
        });
    </script>

</main>

</body>
