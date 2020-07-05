
class TwitterAPI
  def self.post(message)
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_KEY"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      end
    client.update(message)
  end
end

namespace :twitter do
  task post_success: :environment do
    emoji = random_success_emoji
    TwitterAPI.post("[BUILD PASSED] #{emoji}#{random_success_message} '#{commit_message}' #{ENV['CIRCLECI_PROJECT_URL']}#{ENV['CIRCLE_BUILD_NUM']}")
  end

  task post_fail: :environment do
    emoji = random_fail_emoji
    TwitterAPI.post("#{ENV['TWITTER_USERNAME']} [BUILD FAILED] #{emoji}#{random_fail_message} '#{commit_message}' #{ENV['CIRCLECI_PROJECT_URL']}#{ENV['CIRCLE_BUILD_NUM']}")
  end

  private

  def commit_message
    `git log -n 1 --oneline --pretty=format:"%s"`
  end

  def random_success_message
    [
      "テスト通ったわよ！",
      "YOU WIN",
      "百点あげちゃうわ！",
      "パーフェクトでござる",
      "やりますね！",
      "いぇいいぇーいっ！！！",
      "さすがご主人さまです",
      "いいジャン",
      "やるぅーっ",
      "いーーーーーーーねっ！",
      "おつですっ！",
      "テスト通過です",
      "はい勝ちーーー！",
      "ごす！テスト通った！！",
      "ご主人ー！CI通ったよ！",
      "ぱちぱちぱちぱち",
      "えらい！",
      "ワッショイ！",
      "ｲｲﾈ!",
      "さすがっす",
      "きゃー！すてき！",
    ].sample
  end

  def random_fail_message
    [
      "ばかばかっ！テスト落ちてるじゃない！",
      "テストが落ちたわよ",
      "CI失敗してるから確認しなさいっ！",
      "へんじがない　ただのしかばねのようだ",
      "ダメっぽいねこりゃ　だめっぽいっすね",
      "ちょちょちょちょーい！！",
      "こらこらこらこらーっ！",
      "ちょっ...テスト落ちてるわよ！",
      "ぴぴー！ぴぴぴぴぴぴぴーーーー！！",
      "オアーッ",
      "ﾋﾟｩｰﾋﾟｩｰ",
    ].sample
  end

  def random_success_emoji
    "😃😉😗😺👌✌️👍👏🙌🙏💪👦🙆🙋🤴🧙🧚🧜💃🕺👑💌🎆🎇🎉🎊💡🍈🥐🥓🍢🍩🍺🍻🥂💗💯♨️✔️✅⭕🉐🈁🉑㊗️".split("").sample
  end

  def random_fail_emoji
    "🙃🙄🤢😮😞😈💀☠️💩👻👽👾✋👎👊🙅‍♀️🤷‍♀️👮💂👷🧟💣🔪🧨💸⚔️🔫💊🛏️🍌🥒🍤💢💤💔🔔⚠️⛔☢️🔞❗📛❌🈲".split("").sample
  end
end
