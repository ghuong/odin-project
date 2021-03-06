default_grid_dim = 16;
sketchpad_width = 1000;

$(function () {
	sketchpad_width = parseFloat($('.sketchpad').css('width'), 10);
	new_grid(default_grid_dim);
	// New Grid button
	$('button.new-grid').click(new_grid_btn);
});

function new_grid(dim) {
	$('.sketchpad').empty();
	// Create rows
	for (var i = 0; i < dim; i++) {
		$('.sketchpad').append('<div class="sketch-row"></div>');
	}
	// Create 16 squares per row
	for (var i = 0; i < dim; i++) {
		$('.sketch-row').append('<div class="sketch-square"></div>');
	}
	width = (sketchpad_width / dim) + 'px';
	$('.sketch-square').css({
		'width': width, 'height': width
	});
	// On hover, shade square
	$('.sketch-square').hover(shade);
}

function shade() {
	$(this).addClass('shade');
}

function new_grid_btn() {
	dim = parseInt(prompt('New Grid Width:','16'), 10);
	new_grid(dim);
}