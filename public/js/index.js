$(document).ready(function(){
    init();

    setInterval(move_blocks, 3000);
});

function move_blocks(){
    var blocks = $('.block');

    var from = Math.floor(Math.random()*blocks.length);
    var to = Math.floor(Math.random()*blocks.length);

    var from_element = $('#'+blocks[from].id);
    var to_element = $('#'+blocks[to].id);
    from_element.animate({opacity:0.2}, 1000);
    to_element.animate({opacity:0.2}, 1000, function(){
        var tmp = from_element[0].attributes[2].value;
        from_element[0].attributes[2].value = to_element[0].attributes[2].value;
        to_element[0].attributes[2].value = tmp;

        from_element.animate({opacity:1}, 2000);
        to_element.animate({opacity:1}, 2000);
    });
    

}