get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  redirect '/' if current_user
  
  access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  @user = User.find_or_create_by_username(:username => access_token.params[:screen_name])
    @user.oauth_token = access_token.params[:oauth_token]
    @user.oauth_secret = access_token.params[:oauth_token_secret]
    @user.save

  unless @user.oauth_secret.nil?
    @user.fetch_tweets!
    session[:user_id] = @user.id
    session[:oauth_token] = @user.oauth_token
    session[:oauth_token_secret] = @user.oauth_secret
    erb :index
  else
    @messages = "Sorry, we couldn't authenticate you."
    erb :index
  end
end

 
get '/:username' do
  @user = User.find_or_create_by_username(params[:username])
 
  p @user.tweets_stale?

  if @user.tweets_stale?
    erb :get_stale_tweets
  else
    @tweets = @user.tweets.reverse[0..9]
    erb :get_tweets
  end
end
 
post '/fetch/:username' do
  @user = User.find_or_create_by_username(params[:username])
  @user.fetch_tweets! 
  @tweets = @user.tweets.reverse[0..9]
  erb :tweets, :layout => false
end
 
 
get '/:username/followers' do
  @user = User.find_or_create_by_username(params[:username])
 
  if @user.followers_stale?
    erb :get_stale_followers
  else
    @followers = @user.followers
    erb :get_followers
  end
end
 
post '/fetch/:username/followers' do
  @user = User.find_or_create_by_username(params[:username])
  @user.fetch_followers! 
  @followers = @user.followers
 
  erb :followers, :layout => false
end
 
post '/tweet' do
  content_type 'json'

  jid = current_user.tweet(params[:text])
  { 'jid' => jid, 'text' => params[:text] }.to_json
end

get '/status/:job_id' do
  job_is_complete(params[:job_id]).to_s
end

