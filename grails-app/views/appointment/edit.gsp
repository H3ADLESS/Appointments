
<%@ page import="org.springframework.validation.FieldError; appointments.User; appointments.Department; appointments.Lecturer" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout" />
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}"/>

    <title><g:message code="myAppointments.title" default="My Appointments"/> </title>
</head>

<body>

    <div class="mdl-grid">
        %{--<div class="col m12 l12 z-depth-1 settings-box" >--}%
        <div class="mdl-cell mdl-cell--12-col">
            <h5>Termindetails ändern</h5>

            <p>Wenn du einen Termin verschieben möchtest, sage deinen alten Termin bitte ab und buche einen neuen.</p>

            <div id="edit-appointment" class="content scaffold-edit" role="main">

                <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
                </g:if>

                <g:hasErrors bean="${this.appointment}">
                <ul class="errors" role="alert">
                    <g:eachError bean="${this.appointment}" var="error">
                    <li <g:if test="${error in FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
                </ul>
                </g:hasErrors>

                <g:form action="update" resource="${this.appointment}" method="POST">

                    <b>Ihre Daten</b>
                    <div id="user-data">
                        <div class="mdl-cell mdl-cell--12-col">
                            <div style="float: left; width: 5em;">
                                Name:
                            </div>
                            <div style="float: left">
                                ${appointment?.firstName} ${appointment?.lastName}
                            </div>
                        </div> <br>

                        <div class="mdl-cell mdl-cell--12-col">
                            <div style="float: left; width: 5em;">
                                E-Mail:
                            </div>
                            <div style="float: left">
                                ${appointment?.user?.email}
                            </div>
                        </div> <br>

                        <div class="mdl-cell mdl-cell--12-col">
                            Nicht richtig?
                            <input type="button" id="change-user-data" class="mdl-button mdl-js-button mdl-button--primary" value="Ändern"/>
                        </div> <br>
                    </div>

                    <div id="user-data-form" style="display: none">
                        <div class="mdl-cell mdl-cell--12-col">
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="text" id="firstName" name="firstName" value="${appointment?.firstName}">
                                <label class="mdl-textfield__label" for="firstName">Vorname</label>
                            </div>
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="text" id="lastName" name="lastName" value="${appointment?.lastName}">
                                <label class="mdl-textfield__label" for="lastName">Nachname</label>
                            </div>
                        </div>
                        <div class="mdl-cell mdl-cell--12-col">
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="text" id="email" name="email" value="${appointment?.user?.email}">
                                <label class="mdl-textfield__label" for="email">E-Mail</label>
                            </div>
                        </div>
                    </div>

                    <b>Thema</b>
                    <div class="mdl-cell mdl-cell--12-col">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <input class="mdl-textfield__input" type="text" id="subject" name="subject" value="${appointment?.subject}">
                            <label class="mdl-textfield__label" for="subject">Betreff</label>
                        </div>
                    </div>

                    <input type="submit" name="action" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" value="Ändern" id="update">
                    <a style="margin-left: 1em;" type="button" name="delete" class="mdl-button mdl-js-button mdl-button--raised" id="delete" href="${createLink(controller: 'appointment', action: 'delete', id: appointment.id)}">Absagen</a>

                </g:form>
            </div>
        </div>
    </div>

<script>
    $(document).ready(function () {
        $("#change-user-data").on('click', function () {
            $("#user-data-form").show();
            $("#user-data").hide();
        });
    })

</script>

</body>