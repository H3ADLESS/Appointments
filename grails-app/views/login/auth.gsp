<%@ page import="appointments.ApplicationConfig" %>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <title><g:message code='springSecurity.login.title'/></title>
    <style type="text/css" media="screen">

    #center {
        margin: auto;
    }

    #login {
        margin: 15px 0px;
        padding: 0px;
        text-align: center;
    }

    #login .inner {
        width: 340px;
        padding-bottom: 6px;
        margin: 60px auto;
        text-align: left;
        border: 1px solid #aab;
        background-color: #f0f0fa;
        -moz-box-shadow: 2px 2px 2px #eee;
        -webkit-box-shadow: 2px 2px 2px #eee;
        -khtml-box-shadow: 2px 2px 2px #eee;
        box-shadow: 2px 2px 2px #eee;
    }

    #login .inner .fheader {
        padding: 18px 26px 14px 26px;
        background-color: #f7f7ff;
        margin: 0px 0 14px 0;
        color: #2e3741;
        font-size: 18px;
        font-weight: bold;
    }

    #login .inner .cssform p {
        clear: left;
        margin: 0;
        padding: 4px 0 3px 0;
        padding-left: 105px;
        margin-bottom: 20px;
        height: 1%;
    }

    #login .inner .cssform input[type="text"] {
        width: 120px;
    }

    #login .inner .cssform label {
        font-weight: bold;
        float: left;
        text-align: right;
        margin-left: -105px;
        width: 110px;
        padding-top: 3px;
        padding-right: 10px;
    }

    #login #remember_me_holder {
        padding-left: 120px;
    }

    #login #submit {
        margin-left: 15px;
    }

    #login #remember_me_holder label {
        float: none;
        margin-left: 0;
        text-align: left;
        width: 200px
    }

    #login .inner .login_message {
        padding: 6px 25px 20px 25px;
        color: #c33;
    }

    #login .inner .text_ {
        width: 120px;
    }

    #login .inner .chk {
        height: 12px;
    }
    </style>
</head>

<body>

<main>


    <h4 style="margin-left: 48px;"> Anmelden </h4>

    <div>
        <div class="container">

            <div class="mdl-card mdl-shadow--6dp" style="margin: 24px 24px 48px 48px; float: left">
                <div class="mdl-card__title mdl-color--primary mdl-color-text--white">
                    <h2 class="mdl-card__title-text">E-Mail & Password</h2>
                </div>
                <form action="${postUrl ?: '/login/authenticate'}" method="POST" id="loginForm" class="cssform" autocomplete="off">
                    <div class="mdl-card__supporting-text">
                            <div class="mdl-textfield mdl-js-textfield">
                                <input class="mdl-textfield__input" type="text" name="${usernameParameter ?: 'username'}" id="username" />
                                <label class="mdl-textfield__label" for="username">Username</label>
                            </div>
                            <div class="mdl-textfield mdl-js-textfield">
                                <input class="mdl-textfield__input" type="password" name="${passwordParameter ?: 'password'}" id="password" />
                                <label class="mdl-textfield__label" for="password">Password</label>
                            </div>
                    </div>
                    <div class="mdl-card__actions mdl-card--border">
                        <button type="submit" class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect">Log in</button>
                    </div>
                </form>
            </div>

            <g:set var="sakaiUrl" value="${ApplicationConfig.get(1).sakaiUrl}"/>
            <g:if test="${sakaiUrl != null}">

                %{--<div style="float: left; font-size: x-large; padding-top: 5em; font-weight: 100">--}%
                    %{--or--}%
                %{--</div>--}%

                <div class="mdl-card mdl-shadow--6dp" style="margin: 24px 24px 48px 48px; float: left">
                    <div class="mdl-card__title mdl-color--primary mdl-color-text--white">
                        <h2 class="mdl-card__title-text">KVV / Sakai</h2>
                    </div>
                    <div class="mdl-card__supporting-text">
                        <b>Login via Sakai</b> <br> <br>
                        You will be redirected to Sakai-Login.
                    </div>
                    <div class="mdl-card__actions mdl-card--border">
                        <a class="mdl-button mdl-button--colored" href="${sakaiUrl}">Log in</a>
                        %{--<button class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" href="${sakaiUrl}">Log in</button>--}%
                    </div>
                </div>

            </g:if>


            %{--<div class="row">--}%
                %{--<div class="col m12 l12 z-depth-1 settings-box" >--}%

                    %{--<div class="row">--}%

                        %{--<div class="col s6">--}%
                            %{--<g:set var="sakaiUrl" value="${ApplicationConfig.get(1).sakaiUrl}"/>--}%
                            %{--<g:if test="${sakaiUrl != null}">--}%
                                %{--<div class="card">--}%
                                    %{--<div class="card-content">--}%
                                        %{--<span class="card-title">Sakai-Login</span>--}%
                                        %{--<p>Click the link to log in using Sakai.</p>--}%
                                        %{--<br>--}%
                                        %{--<p>--}%
                                            %{--<a href="${sakaiUrl}" class="waves-effect waves-light btn">Sakai-Login</a>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</g:if>--}%
                        %{--</div>--}%

                        %{--<div class="col s6">--}%
                            %{--<div class="card">--}%
                                %{--<div class="card-content">--}%
                                    %{--<span class="card-title">Gäste-Login</span>--}%

                                    %{--<g:if test='${flash.message}'>--}%
                                        %{--<p>--}%
                                            %{--${flash.message}--}%
                                        %{--</p>--}%
                                    %{--</g:if>--}%

                                    %{--<form action="${postUrl ?: '/login/authenticate'}" method="POST" id="loginForm" class="cssform" autocomplete="off">--}%
                                        %{--<p>--}%
                                            %{--<label for="username"><g:message code='springSecurity.login.username.label'/>:</label>--}%
                                            %{--<input type="text" class="text_" name="${usernameParameter ?: 'username'}" id="username"/>--}%
                                        %{--</p>--}%

                                        %{--<p>--}%
                                            %{--<label for="password"><g:message code='springSecurity.login.password.label'/>:</label>--}%
                                            %{--<input type="password" class="text_" name="${passwordParameter ?: 'password'}" id="password"/>--}%
                                        %{--</p>--}%

                                        %{--<p id="remember_me_holder">--}%
                                            %{--<input type="checkbox" class="chk" name="${rememberMeParameter ?: 'remember-me'}" id="remember_me" <g:if test='${hasCookie}'>checked="checked"</g:if>/>--}%
                                            %{--<label for="remember_me"><g:message code='springSecurity.login.remember.me.label'/></label>--}%
                                        %{--</p>--}%
                                        %{--<br>--}%
                                        %{--<p>--}%
                                            %{--<input type="submit" id="submit" class="btn" value="${message(code: 'springSecurity.login.button')}"/>--}%
                                        %{--</p>--}%
                                    %{--</form>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%

                %{--</div>--}%
            %{--</div>--}%
        %{--</div>--}%
    %{--</div>--}%

</main>

<script>
    (function () {
        document.forms['loginForm'].elements['${usernameParameter ?: 'username'}'].focus();
    })();
</script>

</body>
</html>
