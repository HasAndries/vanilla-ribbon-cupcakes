$(document).ready(function(){
    init();
    $('#login_button').click(login);
});

function login(){
    $("#login_error").fadeOut("slow");
    var username = $("#username")[0].value;
    var password = $("#password")[0].value;
    _post('/admin/login',{'username':username,'password':password,'token':$.cookie("token_id")},login_complete,login_error);
}
function login_complete(data){
    $.cookie("token_id", data.token_id);
    $.cookie("username", data.username);
    location.href = '/admin';
}

function login_error(status, error){
    $("#login_error")[0].innerText = (status == 404 ? "Invalid username or password" : "An Error occurred");
    $("#login_error").fadeIn("slow");
}