<g:set var="appointmentCreation" value="${controllerName == 'home' || (controllerName == 'appointment' && (actionName == 'index' || actionName == 'create'))}"/>
<li class="nav-entry ${appointmentCreation? 'active' : ''}" onclick="window.location = '${createLink(controller: 'home')}'">
    Termin vereinbaren
</li>

<sec:ifLoggedIn>
    <g:set var="myAppointments" value="${controllerName == 'appointment' && (actionName == 'list' || actionName == 'show' || actionName == 'edit')}"/>
    <li class="nav-entry ${myAppointments? 'active' : ''}" onclick="window.location='${createLink(controller: 'appointment', action: 'list')}'">
        Meine Termine
    </li>

    <g:set var="settingsMenu" value="${controllerName == 'applicationConfig' || controllerName == 'profile' || controllerName == 'arrangementType' || controllerName == 'notifications' || controllerName == 'register' || controllerName == 'department' || controllerName == 'assistant' }"/>
    <g:set var="officeHourMenu" value="${controllerName == 'officeHourGroup' || controllerName == 'overview' || controllerName == 'officeHour'}"/>

    <g:ifUserIsAssistantOrLecturer>
        <li class="nav-entry collapsible ${officeHourMenu? 'open' : ''}">
            <div class="collapsible-row">
                <span class="collapsible-title"> Sprechstunden </span>
                <span class="expand-icon"><i class="material-icons left ">expand_more</i></span> <span class="expand-less-icon"><i class="material-icons left">expand_less</i></span>
            </div>

            <ul class="collapsible">
                <li class="${(controllerName == 'officeHour' && actionName == 'index')? 'active' : ''}">
                    <a href="${createLink(controller: 'officeHour')}" class="collection-item">Alle Sprechstunden anzeigen</a>
                </li>
                <li class="${(controllerName == 'officeHourGroup' && actionName == 'create')? 'active' : ''}">
                    <a href="${createLink(controller: 'officeHourGroup', action: 'create')}" class="collection-item ${controllerName == 'officeHourGroup' && actionName == 'create' ? 'active' : ''}">Neue Sprechstunde erstellen</a>
                </li>
            </ul>
        </li>
    </g:ifUserIsAssistantOrLecturer>

    <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_LECTURER">
        <li class="nav-entry collapsible ${settingsMenu? 'open' : ''}">
            <div class="collapsible-row">
                <span class="collapsible-title"> Einstellungen </span>
                <span class="expand-icon"><i class="material-icons left">expand_more</i></span> <span class="expand-less-icon"><i class="material-icons left">expand_less</i></span>
            </div>
            <g:render template="/layouts/mdlSettingsMenu"/>
        </li>
    </sec:ifAnyGranted>

    <li class="nav-entry" onclick="window.location='${createLink(controller: 'logoff', method: 'post')}'">
        Logout
    </li>
</sec:ifLoggedIn>

<sec:ifNotLoggedIn>
    <li class="nav-entry" onclick="window.location='${createLink(controller: 'login')}'">
        <a href="${createLink(controller: 'login')}" class="placeholder-for-color">Login</a>
    </li>
</sec:ifNotLoggedIn>


%{--<li class="nav-entry"> <i class="material-icons">expand_more</i> Entry </li>--}%