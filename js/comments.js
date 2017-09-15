function loadCommentsHelper(data) {
  for (var i=0; i<data.length; i++) {
    var cuser = data[i].user.login;
    var cuserlink = data[i].user.html_url;
    var clink = data[i].html_url;
    var cbody = data[i].body_html;
    var cavatarlink = data[i].user.avatar_url;      
    var cdate = new Date(data[i].created_at);
    $("#comments").append(
       "<div class='comment'>" + 
          "<div class='commentheader'>" + 
            "<div class='commentgravatar'>" + 
              '<img src="' + cavatarlink + '" alt="" width="30" height="30">' + 
            "</div>" + 
            "<a class='commentuser' href=\""+ cuserlink + "\">" + 
              cuser + 
            "</a>" + 
            "<a class='commentdate' href=\"" + clink + "\">" + 
              cdate.toLocaleDateString("en") +  
            "</a>" +
          "</div>" + 
          "<div class='commentbody'>" + 
            cbody + 
          "</div>" + 
        "</div>"
    );
  }
}
function loadComments(data) {
/*
  $.ajax("https://api.github.com/repos/mkoohafkan/mkoohafkan.github.io/issues/" + data + "/comments", {
    headers: {Accept: "application/vnd.github.v3.html+json"},
    dataType: "json",
    success: function(msg){
      loadCommentsHelper(msg);
   }});
*/
}
