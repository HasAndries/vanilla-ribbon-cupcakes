function _get(url, data, callback, error_callback){
    _call("GET", url, data, callback, error);
}
function _post(url, data, callback, error_callback){
    _call("POST", url, data, callback, error_callback);
}

function _call(type, url, data, callback, error_callback){
    $.ajax({
        type: type,
        url: url,
        data: data,
        dataType: "json",
        error: function(xhr, status, error){
            if (error_callback) error_callback(xhr.status, error);
            //alert("Something went wrong!");
        },
        success: function(data, status, hxr){
            if (callback) callback(data);
        }
    });
}