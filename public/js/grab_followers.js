$(document).ready(function() {
  var username = window.location.pathname.replace('/','');
  console.log(username);
  var followerPost = { url: '/fetch/' + username, method: 'post' };

  $.ajax(followerPost).done(function(followers){
    console.log(followers);
    $("#follower_content").html(followers);
  });
});
