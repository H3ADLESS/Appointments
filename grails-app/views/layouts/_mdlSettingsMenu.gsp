%{--<div class="col s12 m12 l4">--}%

    <ul class="collapsible">
        <li class="${(controllerName == 'profile' && actionName == 'index')? 'active' : ''}">
            <a href="${createLink(controller: "profile", action: "index")}" class="collection-item ${controllerName == 'profile' && actionName == 'index' ? 'active' : ''}">Profil bearbeiten</a>
        </li>

        <li class="${(controllerName == 'arrangementType' && actionName == 'index')? 'active' : ''}">
            <a href="${createLink(controller: 'arrangementType', action: 'index')}" class="collection-item ${controllerName == 'arrangementType' && actionName == 'index' ? 'active' : ''}">Art der Terminvereinbarung</a>
        </li>

        <li class="${(controllerName == 'notifications' && actionName == 'index')? 'active' : ''}">
            <a href="${createLink(controller: 'notifications', action: 'index')}" class="collection-item ${controllerName == 'notifications' && actionName == 'index' ? 'active' : ''}">Benachrichtigungen</a>
        </li>

        <li class="${(controllerName == 'register' && actionName == 'index')? 'active' : ''}">
            <a href="${createLink(controller: 'register')}" class="collection-item ${controllerName == 'register' && actionName == 'index' ? 'active' : ''}">Nutzer registrieren</a>
        </li>

        <li class="${(controllerName == 'assistant' && actionName == 'index')? 'active' : ''}">
            <a href="${createLink(controller: 'assistant')}" class="collection-item ${controllerName == 'assistant' && actionName == 'index' ? 'active' : ''}">Assistent hinzufügen</a>
        </li>

        <sec:ifAllGranted roles="ROLE_ADMIN">
            <li class="${(controllerName == 'applicationConfig' && actionName == 'index')? 'active' : ''}">
                <a href="${createLink(controller: 'applicationConfig')}" class="collection-item ${controllerName == 'applicationConfig' && actionName == 'index' ? 'active' : ''}">System-Einstellungen</a>
            </li>

            <li class="${(controllerName == 'department' && actionName == 'index')? 'active' : ''}">
                <a href="${createLink(controller: 'department')}" class="collection-item ${controllerName == 'department' && actionName == 'index' ? 'active' : ''}">Fachbereiche</a>
            </li>
        </sec:ifAllGranted>
    </ul>

%{--</div>--}%

