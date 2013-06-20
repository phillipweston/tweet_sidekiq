$(document).ready(function() {
  var username = window.location.pathname.replace('/','');

  var tweetPost = { url: '/fetch/' + username, method: 'post' };
  
  $.ajax(tweetPost).done(function(tweets){
    $("#tweet_content").html(tweets);
  });
});
