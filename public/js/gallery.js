$(document).ready(function(){
    init();
});

$(window).load(function() {
    load_sliders();
});

function load_sliders(){
    $('#gallery0').nivoSlider({
        controlNavThumbs:true,
        controlNavThumbsSearch: ".png",
        controlNavThumbsReplace: "_thumb.png",
        effect: "slideInRight",
        manualAdvance:true
    });
    $('#gallery1').nivoSlider({
        controlNavThumbs:true,
        controlNavThumbsSearch: ".png",
        controlNavThumbsReplace: "_thumb.png",
        effect: "slideInRight",
        manualAdvance:true
    });
}