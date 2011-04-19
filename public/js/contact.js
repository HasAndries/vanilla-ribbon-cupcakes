$(document).ready(function(){
    init();

    setInterval(move_blocks, 1000);
});

function move_blocks(){
    var blocks = $('.block');

    var from = Math.floor(Math.random()*blocks.length);
    var to = Math.floor(Math.random()*blocks.length);

    var from_element = $('#'+blocks[from].id);
    var to_element = $('#'+blocks[to].id);

    var from_color = from_element[0].style.backgroundColor;
    var to_color = to_element[0].style.backgroundColor;

    from_element.animate({backgroundColor: to_color}, 1000);
    to_element.animate({backgroundColor: from_color}, 1000);
//    from_element.animate({opacity:0.5}, 300);
//    to_element.animate({opacity:0.5}, 300, function(){
//        var tmp = from_element[0].attributes[2].value;
//        from_element[0].attributes[2].value = to_element[0].attributes[2].value;
//        to_element[0].attributes[2].value = tmp;
//
//        from_element.animate({opacity:1}, 700);
//        to_element.animate({opacity:1}, 700);
//    });
}