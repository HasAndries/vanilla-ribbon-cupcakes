$(document).ready(function(){
    loadProducts();
});

function loadProducts(){
    jQuery.getJSON('/product', function(data){
        var items = [];

        $.each(data.items, function(i, item) {
            items.push('<li id="' + item.name + '">' + item.name + '</li>');
        });

        var list = $('<ul/>', {
            'class': 'my-new-list',
            html: items.join('')
        });

        $('#content').append(list);
    })
}