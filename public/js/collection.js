$(document).ready(function(){
    init();
});

$(window).load(function() {
    load_sliders();
});

function load_sliders(){
    $('#gallery').nivoSlider({
        controlNavThumbs:true,
        controlNavThumbsSearch: ".png",
        controlNavThumbsReplace: "_thumb.png",
        effect: "slideInRight",
        manualAdvance:true
    });
}