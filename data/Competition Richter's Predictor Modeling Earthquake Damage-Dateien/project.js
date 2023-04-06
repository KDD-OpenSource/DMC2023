$('.navbar-toggle').click(function(){
	$('body').toggleClass('menu-active');
})

// Make Boostrap dropdowns more accessible

$(document).on('shown.bs.dropdown', function(event) {
    var dropdown = $(event.target);
    dropdown.find('.dropdown-menu').attr('aria-expanded', true);

    setTimeout(function() {
        dropdown.find('.dropdown-menu li:first-child a').focus();
    }, 10);
});

$(document).on('hidden.bs.dropdown', function(event) {
    var dropdown = $(event.target);
    dropdown.find('.dropdown-menu').attr('aria-expanded', false);
    dropdown.find('.dropdown-toggle').focus();
});