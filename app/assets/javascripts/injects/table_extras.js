// Make rows clickable
$(document).on('click', '.table tr', function(event) {
    var target = $(event.target);
    if (target.is(":not(a)") && target.is(":not(span)")) {
        var href = $(this).data("link");
        if (href) {
            window.location.href = href;
        }
    }
});

$(document).on('click', '.collapser', function(e) {
    // Change button icon
    if ($(this).hasClass('collapsed')) {
        $(this).find('.glyphicon-circle-arrow-down').first()
            .removeClass('glyphicon-circle-arrow-down')
            .addClass('glyphicon-circle-arrow-up');
    } else {
        $(this).find('.glyphicon-circle-arrow-up').first()
            .removeClass('glyphicon-circle-arrow-up')
            .addClass('glyphicon-circle-arrow-down');
    }

    var snippetRow = $(this).parent().parent();

    // Smooth scrolling
    $('html, body').animate({
        scrollTop: $(snippetRow).position().top - $(snippetRow).height()
    }, 600);
});