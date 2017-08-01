<%@ page import="appointments.DateUtils; appointments.User" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <title>Sprechstunden</title>
</head>
<body>

<main>

    <div class="mdl-grid">
        <div class="mdl-cell mdl-cell--12-col">
            <h4>Termin "${this.appointment.subject}" erfolgreich reserviert</h4>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <div class="icon-label">
                <i class="material-icons md-dark icon-height">face</i>
            </div>
            <div class="left">${this.appointment.officeHour.lecturer.name}</div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <div class="icon-label">
                <i class="material-icons md-dark icon-height">event</i>
            </div>
            <div class="left"><g:formatDate date="${this.appointment.start}" formatName="default.date.format.date"/></div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <div class="icon-label">
                <i class="material-icons md-dark icon-height">schedule</i>
            </div>
            <div class="left">
                <g:formatDate date="${this.appointment.start}" formatName="default.date.format.time"/> bis <g:formatDate date="${this.appointment.end}" formatName="default.date.format.time"/> Uhr
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <div class="icon-label">
                <i class="material-icons md-dark icon-height">place</i>
            </div>
            <div class="icon-info">
                ${this.appointment.officeHour.lecturer.street} ${this.appointment.officeHour.lecturer.number} <br>
                ${this.appointment.officeHour.lecturer.zip} ${this.appointment.officeHour.lecturer.city} <br>
                Etage: ${this.appointment.officeHour.lecturer.floor}, Raum: ${this.appointment.officeHour.lecturer.room}
            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col" style="margin: 12px auto">
            Bitte sage deinen Termin frühzeitig ab, falls du ihn nicht wahrnehmen kannst.
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <a class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" href="${createLink(controller: 'appointment', action: 'index', id: "${this.appointment.officeHour.lecturer.id}", params: ["date":"${appointments.DateUtils.resetTime(this.appointment.start).getTime()}"])}">
                <i class="material-icons left">home</i> Zurück
            </a>

            <a class="mdl-button mdl-js-button mdl-button--raised" href="${createLink(action: 'edit', id: this.appointment.id)}">
                <i class="material-icons left">mode_edit</i> Bearbeiten
            </a>
        </div>

    </div>

</main>

</body>
</html>
