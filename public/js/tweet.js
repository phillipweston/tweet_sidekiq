function pollJid(jid, text) {
  var checkStatus = setInterval(function(){   
    $.get('/status/' + jid).done(function(trueorfalse){ 
      if (trueorfalse === 'true') {
        updateDOM(text);
        clearInterval(checkStatus);
      }
    });
  }, 1000);
}

function updateDOM(text) {
  $('#tweets').prepend('<p>' + text + '</p>');
  $('#spinner').css('display', 'none');
  $('.tweet input[name="text"]').val('');
}

function postTweet(form) {
  $('#spinner').css('display', 'block');
  var tweetPost = { url: '/tweet', method: 'post', data: form.serialize() };
  $.ajax(tweetPost).done(function(response){
      pollJid(response['jid'], response['text']);
    });
}

$(document).ready(function() {
  $('.tweet').on('submit', function(e){
    e.preventDefault();
    postTweet($(this)); 
  });
});