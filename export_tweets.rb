# Exports all tweets from a user into a plaintext file
require 'dotenv/load'
require 'twitter'

class TweetExporter
  # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
  def initialize(oauth_token, oauth_token_secret, access_token, access_secret, outfile="exported_tweets-#{Time.now.to_i}.out.txt")
    @tweets = []
    @outfile=outfile
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = oauth_token
      config.consumer_secret     = oauth_token_secret
      config.access_token        = access_token
      config.access_token_secret = access_secret
    end
  end

  def get_tweets(user)
    @tweets = @client.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{user}&count=200&include_rts=false")
    self
  end

  def get_tweets_with_max_id(user, maxId)
    @tweets = @client.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{user}&max_id=#{maxId}&count=200&include_rts=false")
    self
  end

  def append_to_file(skipFirst=false)
    open(@outfile, 'a') do |f|
      @tweets.drop(skipFirst ? 1 : 0).each do |tweet|
        f.puts tweet[:text]
      end
    end
  end

  def get_last_id
    @tweets.last[:id]
  end
end

consumer_key=ENV['CONSUMER_KEY']
consumer_secret=ENV['CONSUMER_SECRET']
access_token=ENV['ACCESS_TOKEN']
access_token_secret=ENV['ACCESS_TOKEN_SECRET']


twitter_user='realDonaldTrump'
exporter = TweetExporter.new consumer_key, consumer_secret, access_token, access_token_secret
exporter.get_tweets(twitter_user)
last_id = exporter.get_last_id
exporter.append_to_file

17.times do  # Unfortunately we only can get 3600 tweets (200 tweets at a time)
  exporter.get_tweets_with_max_id(twitter_user, last_id)
  exporter.append_to_file(true)
  last_id = exporter.get_last_id
end