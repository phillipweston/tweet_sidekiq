def current_user
	User.find(session[:user_id]) if session[:user_id]
end

def twitter_user
	Twitter::Client.new(
  	:oauth_token => session[:oauth_token],
  	:oauth_token_secret => session[:oauth_token_secret]
	) if session[:user_id]
end