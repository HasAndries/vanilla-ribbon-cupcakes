//--------------------Layout---------------------------
function layout(){
    $("#header").load("parts/header.html");
    $("#menu").load("parts/menu.html");
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