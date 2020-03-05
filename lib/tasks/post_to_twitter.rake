
class TwitterAPI
  def self.post(messsage)
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_KEY"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      end
    client.update(messsage)
  end
end

namespace :twitter do
  task post_success: :environment do
    TwitterAPI.post("テスト通ったわよ！ https://circleci.com/gh/jyllsarta/stray/#{ENV['CIRCLE_BUILD_NUM']}")
  end

  task post_fail: :environment do
    TwitterAPI.post("@jyll ばかばかっ！テスト落ちてるよ！！ https://circleci.com/gh/jyllsarta/stray/#{ENV['CIRCLE_BUILD_NUM']}")
  end
end
