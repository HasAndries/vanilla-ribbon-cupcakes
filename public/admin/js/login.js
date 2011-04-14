$(document).ready(function(){
    layout();

    $('#loginButton').click(login);
});

function login(){
    var username = $("#username")[0].value;
    var password = $("#password")[0].value;
    _post('/admin/login', {'username': username, 'password': password}, login_complete);
}
function login_complete(data){
    alert(data);
}