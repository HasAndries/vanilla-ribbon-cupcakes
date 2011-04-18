//--------------------Init----------------------
function init(){
    
}

//--------------------Common--------------------
function show_error(error){
    $("#common_error")[0].innerText = error;
    error.length > 0 ? $("#login_error").fadeIn("slow") : $("#common_error").fadeOut("slow");
}
