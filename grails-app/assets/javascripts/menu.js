/** Mobile Navigation **/

$(document).ready(function() {
    var menuButton = $(".left-hand-menu, .right-hand-menu");
    var mobileMenu = $(".mobile-menu");
    var collapsibleEntries = $(".nav-entry.collapsible");

    var activeEntry = $(".nav-entry.collapsible.open");
    if (activeEntry) {
        activeEntry.children('ul').show();
        activeEntry.children('.expand-icon').toggle();
        activeEntry.children('.expand-less-icon').toggle();
    }

    // var collapsibleEntries = $("ul.collapsible");

    menuButton.on("click", function() {
        console.log("Menu clicked");
        // mobileMenu.toggle();
        mobileMenu.slideToggle();
    });

    collapsibleEntries.on("click", function() {
        console.log("Collapsible entry clicked");
        console.log($(this));
        $(this).children('ul').slideToggle();
        $(this).children('.expand-icon').toggle();
        $(this).children('.expand-less-icon').toggle();
    });


    $(window).resize(function() {
        if ($( window ).width() > 1023 ) {
            mobileMenu.hide();
        }
    });
});

