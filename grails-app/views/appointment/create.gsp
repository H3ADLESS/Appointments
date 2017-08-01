<%@ page import="appointments.DateUtils; appointments.User; appointments.OfficeHour" %>
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
                        %{--<div style="margin: auto">2</div>--}%
                        <div style="margin: auto"><i class="material-icons">done</i></div>
                    </div>
                    <div class="stepper-text">
                        Termin wählen
                        %{--<a href="${createLink(controller: 'appointment', action: 'index', id: lecturer?.id)}">Startzeitpunkt des Termins wählen</a>--}%
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="step active">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">3</div>
                    </div>
                    <div class="stepper-text">
                        Eckdaten mitteilen
                    </div>
                </div>

            </div>

        </div>


        <div class="mdl-cell mdl-cell--12-col">
            <h5>Termin für <g:formatDate formatName="default.weekdayDate.format" date="${appointment?.start}"/> Uhr bis <g:formatDate formatName="default.date.format.time" date="${appointment?.end}"/> Uhr</h5>
            <div>bei ${appointment?.officeHour?.lecturer?.name} </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">

            <g:form action="save" method="post" class="col s12">

                <g:render template="/layouts/message"/>

                %{-- invisible data --}%
                <input id="date" name="date" value="${appointment?.start?.getTime()}" style="display: none">
                <input id="officeHour" name="officeHour" value="${appointment?.officeHour?.id}" style="display: none">
                <input id="duration" name="duration" value="${appointment?.duration}" style="display: none">

                <div class="mdl-cell mdl-cell--12-col">

                    <b>Ihre Daten</b>
                    <div id="user-data">
                        <div class="mdl-cell mdl-cell--12-col">
                            <div style="float: left; width: 5em;">
                                Name:
                            </div>
                            <div style="float: left">
                                ${appointment?.user?.firstName} ${appointment?.user?.lastName}
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
                                <input class="mdl-textfield__input" type="text" id="firstName" name="firstName" value="${appointment?.user?.firstName}">
                                <label class="mdl-textfield__label" for="firstName">Vorname</label>
                            </div>
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="text" id="lastName" name="lastName" value="${appointment?.user?.lastName}">
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

                    <b>Betreff</b>
                    <div class="mdl-cell mdl-cell--12-col">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <input class="mdl-textfield__input" type="text" id="subject" name="subject" value="${appointment?.subject}">
                            <label class="mdl-textfield__label" for="subject">Betreff*</label>
                            <span class="mdl-textfield__error">Bitte gib ein Betreff an!</span>
                        </div>
                    </div>

                    <div class="mdl-cell mdl-cell--12-col" style="margin-top: 2em;">
                        Hinweis: Termine können auch nach dem Buchen noch bearbeitet werden. Siehe <a href="${createLink(controller: 'appointment', action: 'list')}">Meine Termine</a>.
                    </div>

                    <br>

                    <input type="submit" name="action" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored" value="Termin buchen" id="create">
                    <a style="margin-left: 1em;" href="${createLink(controller: 'appointment', action: 'index', id: appointment?.officeHour?.lecturer?.id, params: [date: DateUtils.resetTime(appointment?.officeHour?.start).getTime()])}" class="mdl-button mdl-js-button mdl-button--raised">Abbrechen</a>
                </div>

            </g:form>
        </div>



    <script>
        $(document).ready(function () {
            $("#change-user-data").on('click', function () {
                $("#user-data-form").show();
                $("#user-data").hide();
            });
        })

    </script>

</main>
</body>
</html>
