//--------------------Layout---------------------------
function layout(){
    $("#header").load("parts/header.html");
    $('#footer').load("parts/footer.html");

    //loadNews();
}

//--------------------News-----------------------------
function loadNews(){
//    $("#scroller").live("smoothDivScroll", ({
//        autoScroll: "onstart",
//        autoScrollDirection: "endlessloopright",
//        autoScrollInterval: 1,
//        autoScrollStep: 1
//    }));
    $("#news").load("parts/news.html", function(){
        var scroller = $("#scroller");
        var news = $("#news");
        $("#scroller").smoothDivScroll({
            autoScroll: "onstart",
            autoScrollDirection: "endlessloopright",
            autoScrollInterval: 1,
            autoScrollStep: 1
        });
    });
}
function loadNewsComplete(){

}

//--------------------Service Calls--------------------
function _get(url, data, callback){
    _call("GET", url, data, callback);
}
function _post(url, data, callback){
    _call("POST", url, data, callback);
}

function _call(type, url, data, callback){
    $.ajax({
        type: type,
        url: url,
        data: data,
        dataType: "json",
        error: function(){ alert("Something went wrong!"); },
        success: function(message){ if (callback) callback(message);}
    });
}