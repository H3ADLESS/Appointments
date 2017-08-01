<div id="tutorial" class="card mdl-card mdl-shadow--2dp">
    <div class="mdl-card__title">
        <h1 class="mdl-card__title-text">Wilkommen</h1>
    </div>
    <div class="mdl-card__supporting-text">
        Es scheint als wäre das Ihr erster Besuch. Um diese Anwendung nutzen zu können gehen Sie wie folgt vor:<br>
        <ol>
            <li>
                Legen Sie Ihr Profil an und geben Sie es frei. <br>
                %{--<a style="margin-left: 1em" href="${createLink(controller: 'profile', action: 'index')}">Mein Profil anlegen</a>--}%
            </li>
            <li>
                Legen Sie Ihre ersten Sprechstunden an. <br>
                %{--<a style="margin-left: 1em" href="${createLink(controller: 'profile', action: 'index')}">Meine erste Sprechstunde anlegen</a>--}%
            </li>
        </ol>
        Viel Erfolg bei Forschung und Lehre!
    </div>
    <div class="mdl-card__actions mdl-card--border">
        <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" href="${createLink(controller: 'profile', action: 'index')}">
            Profil anlegen
        </a>
        <g:ifUserIsLecturerAndProfileIsInactive>
            <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" disabled>
                Sprechstunde anlegen
            </a>
        </g:ifUserIsLecturerAndProfileIsInactive>
        <g:ifUserIsLecturerAndProfileIsActive>
            <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" href="${createLink(controller: 'officeHourGroup', action: 'create')}">
                Sprechstunde anlegen
            </a>
        </g:ifUserIsLecturerAndProfileIsActive>
        <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" onclick="closeTutorialAndDontShowAgain()">
            Nicht mehr anzeigen
        </a>
    </div>
    <div class="mdl-card__menu">
        <button class="mdl-button mdl-button--icon mdl-js-button mdl-js-ripple-effect" style="color: white" onclick="closeTutorial()">
            <i class="material-icons">close</i>
        </button>
    </div>
</div>

<script>
    function closeTutorialAndDontShowAgain(){
        closeTutorial();
        $.ajax({
            url: "${createLink(controller: 'profile', action: 'disableTutorial')}"
        })
    }

    function closeTutorial() {
        $("#tutorial").hide();
    }
</script>