<g:ifUserIsLecturerAndProfileIsInactive>
    <div class="mdl-grid">
        <div class="mdl-cell mdl-cell--12-col">
            <div class="flash message">
                <i class="material-icons">warning</i>
                <div class="message" style="display: block">Ihr Profil ist derzeit nicht aktiv. Um eigene Sprechstunden zu erstellen aktivieren Sie ihr <a href="${createLink(controller: 'profile', action: 'index')}">Profil</a>. </div>
            </div>
        </div>
    </div>
</g:ifUserIsLecturerAndProfileIsInactive>