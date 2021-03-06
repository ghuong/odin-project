sliderIdx = 1;
sliderCount = 1;

$(function () {
	$('#slider > img#1').fadeIn(300);
	startSlider();
	$('a.prev').click(prevSlide);
	$('a.next').click(nextSlide);
	$('#slider > img').hover(stopLoop, startSlider);
});

function startSlider() {
	sliderCount = $('#slider > img').length;
	loop = setInterval(function() {
		incrSliderIdx();
		showCurrentSlide();
	}, 3000);
}

function decrSliderIdx() {
	sliderIdx = (sliderIdx - 2).mod(sliderCount) + 1;
}

function incrSliderIdx() {
	sliderIdx = sliderIdx.mod(sliderCount) + 1;
}

function prevSlide() {
	decrSliderIdx();
	refreshSlider();
}

function nextSlide() {
	incrSliderIdx();
	refreshSlider();
}

function refreshSlider() {
	stopLoop();
	showCurrentSlide();
	startSlider();
}

function showCurrentSlide() {
	$('#slider > img').fadeOut(300);
	$('#slider > img#' + sliderIdx).fadeIn(300);
}

function stopLoop() {
	window.clearInterval(loop);
}