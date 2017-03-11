# Exports all tweets from a user into a plaintext file
require 'dotenv/load'
require 'twitter'
class ExportTweets
  # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
  @tweets = ''
  def prepare_access_token(oauth_token, oauth_token_secret, access_token, access_secret)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = oauth_token
      config.consumer_secret     = oauth_token_secret
      config.access_token        =  access_token
      config.access_token_secret = access_secret
    end
    client
  end
  def get_tweets(client, user)
    @tweets=client.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{user}")
    self
  end
  def get_tweets_with_max_id(client, user, maxId)
    @tweets=client.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{user}&max_id=#{maxId}")
    self
  end
  def add_tweet_to_file(tweet, outfile='exported_tweets.out.txt')
    open(outfile, 'a') do |f|
      f.puts tweet
    end
    self
  end
  def add_tweets_to_file(offset)
    @tweets.drop(offset).each do |tweet|
      add_tweet_to_file(tweet[:text])
      self
    end
  end
  def get_last_id
    @tweets.last[:id]
  end

end

consumer_key=ENV['CONSUMER_KEY']
consume_secret=ENV['CONSUMER_SECRET']
access_token=ENV['ACCESS_TOKEN']
access_token_secret=ENV['ACCESS_TOKEN_SECRET']


twitter_user='realDonaldTrump'
client = ExportTweets.new.prepare_access_token(consumer_key, consume_secret, access_token, access_token_secret)
first_donald_tweets=ExportTweets.new.get_tweets(client, twitter_user)
id=first_donald_tweets.get_last_id
first_donald_tweets.add_tweets_to_file(0)

x=0
until x==1 do
  begin
    y = ExportTweets.new.get_tweets_with_max_id(client, twitter_user, id)
    y.add_tweets_to_file(1)
    id=y.get_last_id
    sleep 60
  rescue => hopefully_last
    x=1
    p hopefully_last
  end
end
