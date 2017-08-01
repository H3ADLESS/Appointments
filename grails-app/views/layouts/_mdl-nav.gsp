<header class="mdl-layout__header mdl-layout__header--scroll" style="margin-left: 0; width: 100%">
    <header class="fu-header" style="background-color: white">
        <a class="fu-logo" href="${createLink(controller: 'home')}" title="Zur Startseite">
            <picture>
                <source srcset="${assetPath(src: 'fu-logo-1x.png')} 1x, ${assetPath(src: 'fu-logo-2x.png')} 2x, ${assetPath(src: 'fu-logo.png')} 3x">
                <img id="default-logo" alt="Logo der Freien Universität Berlin" src="${assetPath(src: 'fu-logo.png')}">
            </picture>

            <span><img alt="Logo der Freien Universität Berlin" src="${assetPath(src: 'fu-logo-mobile.png')}"></span>
        </a>
    </header>
    <div class="grey-header">
        <div style="color: black; float: right; margin-right: 1em;"> <g:username/> </div>
    </div>

    <div class="mdl-layout__header-row">
        <span class="left-hand-menu"><i class="material-icons">menu</i> </span>
        <span class="mdl-layout-title green-bar" style="max-width: 70%">Sprechstunden an der FU-Berlin</span>
        <div class="mdl-layout-spacer"></div>
        <span class="right-hand-menu">MENÜ</span>
    </div>

    <div class="mobile-menu">
        <ul class="menu-entries" style="margin: 0; padding: 0;">
            <g:render template="/layouts/navigationEntries"/>
        </ul>
    </div>

</header>