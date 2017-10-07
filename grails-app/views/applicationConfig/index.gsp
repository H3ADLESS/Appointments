<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}"/>
    <title>${entityName} - Einstellungen</title>
</head>

<body>

<div class="mdl-grid">

    <div class="mdl-cell mdl-cell--12-col">
        <h4>System-Einstellungen</h4>
    </div>

    <form action="update" method="post">
        Diese Einstellungen ändern das Verhalten der gesamten Anwendung.
        <div style="margin: 2em auto"></div>
        <b>Locale</b>

        <div class="row">
            <div class="input-field col s12">
                <select id="locale" name="locale">
                %{--<option value="" disabled selected>Choose your option</option>--}%
                    <g:each in="${Locale.availableLocales.sort()}">
                        <g:if test="${Locale.getDefault() == it}">
                            <option value="${it}" selected>${it.displayName}</option>
                        </g:if>
                        <g:else>
                            <option value="${it}">${it.displayName}</option>
                        </g:else>
                    </g:each>
                </select>
                <label for="locale">Locale</label>
            </div>
        </div>
        <b>LTI</b>

        <div class="row">
            <div class="input-field col s6">
                <input id="ltiKey" name="ltiKey" type="text" value="${config?.ltiKey}">
                <label for="ltiKey">LTI-Key</label>
            </div>

            <div class="input-field col s6">
                <input id="ltiSecret" name="ltiSecret" type="password" value="${config?.ltiSecret}">
                <label for="ltiSecret">LTI-Secret</label>
            </div>
        </div>

        <div style="margin: 2em auto"></div>
        <b>LTI-Roles</b>

        <div class="row">
            <div class="input-field col s12">
                <input id="litRoleAdmin" name="litRoleAdmin" type="text" value="${config?.litRoleAdmin}">
                <label for="litRoleAdmin">litRoleAdmin</label>
            </div>

            <div class="input-field col s12">
                <input id="litRoleInstructor" name="litRoleInstructor" type="text" value="${config?.litRoleInstructor}">
                <label for="litRoleInstructor">litRoleInstructor</label>
            </div>

            <div class="input-field col s12">
                <input id="ltiRoleTeachingAssistant" name="ltiRoleTeachingAssistant" type="text" value="${config?.ltiRoleTeachingAssistant}">
                <label for="ltiRoleTeachingAssistant">ltiRoleTeachingAssistant</label>
            </div>

            <div class="input-field col s12">
                <input id="ltiRoleStudent" name="ltiRoleStudent" type="text" value="${config?.ltiRoleStudent}">
                <label for="ltiRoleStudent">ltiRoleStudent</label>
            </div>


            <div class="input-field col s12">
                <input id="applicationLogo1x" name="applicationLogo1x" type="text" value="${config?.applicationLogo1x}">
                <label for="applicationLogo1x">Application Logo 1x</label>
            </div>
            <div class="input-field col s12">
                <input id="applicationLogo2x" name="applicationLogo2x" type="text" value="${config?.applicationLogo2x}">
                <label for="applicationLogo2x">Application Logo 2x</label>
            </div>
            <div class="input-field col s12">
                <input id="applicationLogo3x" name="applicationLogo3x" type="text" value="${config?.applicationLogo3x}">
                <label for="applicationLogo3x">Application Logo 3x</label>
            </div>
            <div class="input-field col s12">
                <input id="applicationLogoMobile" name="applicationLogoMobile" type="text" value="${config?.applicationLogoMobile}">
                <label for="applicationLogoMobile">Application Logo Mobile</label>
            </div>
            <div class="input-field col s12">
                <input id="favIcon" name="favIcon" type="text" value="${config?.favIcon}">
                <label for="favIcon">favIcon</label>
            </div>

        </div>

        <div style="margin: 2em auto"></div>

        <input type="submit" name="update" class="save btn" value="${message(code: "default.button.update.label")}" id="create">

    </form>
</div>

<script>
    $(document).ready(function () {
        $('select').material_select();
    });
</script>

</body>
</html>