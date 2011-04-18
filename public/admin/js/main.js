//--------------------Init----------------------
function init(){
    $("#logout_button").click(logout);
}

//--------------------Common--------------------
function show_error(error){
    $("#common_error")[0].innerText = error;
    error.length > 0 ? $("#login_error").fadeIn("slow") : $("#common_error").fadeOut("slow");
}

//--------------------Logout--------------------
function logout(){
    _post('/admin/logout', {}, logout_complete, logout_error);
}
function logout_complete(data){
    $.cookie("token_id", null);
    $.cookie("username", null);
    location.href = '/admin/login';
}
function logout_error(status, error){
    show_error(error);
}