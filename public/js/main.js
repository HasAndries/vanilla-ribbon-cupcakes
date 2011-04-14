//--------------------Layout---------------------------
function layout(){
    //header
    $("#header").load("parts/header.html");
    //footer
    $('#footer').load('parts/footer.html');
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