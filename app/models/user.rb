class User < ActiveRecord::Base
  has_many :tweets
  has_many :followers

  def tweet(text)
    tweet = tweets.create!(:text => text)
    TweetWorker.perform_async(tweet.id)
  end

  def fetch_tweets!
    Twitter.user_timeline(self.username).reverse.each do |tweet|
      self.tweets << Tweet.find_or_create_by_text_and_tweeted_at(tweet.attrs[:text], tweet.attrs[:created_at])
      self.touch
    end
  end

  def fetch_followers!
    Twitter.followers(self.username).each do |user|
      self.followers << Follower.find_or_create_by_username(user.attrs[:screen_name])
      self.touch
    end
  end

  def tweets_stale?
    return "first" if self.tweets.empty?
    last_post_days_old = (Time.now - self.tweets[-1].tweeted_at)/60/60/24
    return "second" if last_post_days_old < 1 && self.updated_at > 15.minutes.ago  
    return "third" if last_post_days_old >= 1 && self.updated_at > 1.hour.ago
    false
  end

  def followers_stale?
    self.followers.empty?
  end


end
