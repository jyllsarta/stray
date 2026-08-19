return unless  ENV["SENTRY_DSN"]

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.breadcrumbs_logger = [:active_support_logger]

  # パフォーマンス計測(Transaction)は無料枠を食い尽くして429を連発するため無効化。
  # エラーイベントのみ送信する。
  config.traces_sample_rate = 0.0
end
