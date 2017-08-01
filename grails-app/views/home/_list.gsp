<%@ page import="appointments.ArrangementType; appointments.Lecturer; appointments.OfficeHour" %>

    <g:if test="${lecturers == null || lecturers.size() == 0}">
        Keine Ergebnisse
    </g:if>
    <g:else>
        <g:each status="i" in="${lecturers}" var="lecturer">

        <g:if test="${i%2 == 0}">
        %{-- clear to keep cards in lines --}%
            %{--<div style="clear: both; width: 100%; height: 1px;"></div>--}%
        </g:if>

        <div class="mdl-cell mdl-cell--4-col-xl mdl-cell--6-col mdl-cell--12-col-phone mdl-cell--12-col-tablet lecturer-cell">

            <div class="card mdl-card lecturer mdl-shadow--2dp lecturer-card">

                <div class="card-picture">
                    <g:if test="${lecturer?.imageUrl}">
                        <div class="circle" style="background-image: url('${lecturer?.imageUrl}')"> </div>
                    </g:if>
                    <g:else>
                        <div class="circle">
                            <asset:image src="profile-placeholder.png" width="128px"/>
                        </div>
                    </g:else>
                </div>

                <div class="card-headline-container">
                    <h4>${lecturer?.title} ${lecturer?.firstName} ${lecturer?.lastName}</h4>
                </div>

                <div class="card-content mdl-card__title mdl-card--expand lecturer-card-content">
                    <div class="card-photo">
                        <g:if test="${lecturer?.imageUrl}">
                            <div class="circle" style="background-image: url('${lecturer?.imageUrl}')"> </div>
                        </g:if>
                        <g:else>
                            <div class="circle">
                                <asset:image src="profile-placeholder.png" width="128px"/>
                            </div>
                        </g:else>
                    </div>

                    <div class="mdl-card__supporting-text no-top-bot-padding">
                        %{--<span class="card-title">${lecturer?.title} ${lecturer?.firstName} ${lecturer?.lastName}</span>--}%

                        <p>
                            <b>Adresse</b> <br>
                            ${lecturer?.street} ${lecturer?.number}, ${lecturer?.zip} ${lecturer?.city} <br>
                            Raum ${lecturer?.room}, Etage ${lecturer?.floor} <br> <br>

                            <b>E-Mail</b> <br>
                            ${lecturer?.email} <br> <br>

                            <b>Sprechzeiten</b> <br>

                            <g:set var="officeHour" value="${OfficeHour.findByLecturerAndStartGreaterThanAndDeadlineGreaterThan(lecturer, new Date(), new Date(), [sort: 'start', max: 1])}"/>
                            <g:if test="${officeHour != null && lecturer.userSettings.arrangementType == ArrangementType.USE_APP}">
                                Die nächste Sprechstunde ist am <g:formatDate date="${officeHour.start}" formatName="default.date.format.date"/>
                            </g:if>
                            <g:elseif test="${lecturer.userSettings.arrangementType != ArrangementType.USE_APP}">
                                Bitte vereinbare deinen Termin individuell.
                            </g:elseif>
                            <g:else>
                                Derzeit werden keine Sprechstunden angeboten.
                            </g:else>
                        </p>
                    </div>

                </div>

                <div class="mdl-card__actions mdl-card--border">
                    <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" href="${createLink(controller: 'appointment', action: 'index', id: lecturer?.id)}">
                        Termin vereinbaren
                    </a>
                </div>
            </div>

        </div>

    </g:each>
    </g:else>
</div>