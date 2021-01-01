class CustomLogger < Rails::Rack::Logger
  def call(env)
    super
  end
end


Rails.application.config.middleware.swap Rails::Rack::Logger, CustomLogger, [
  ->(req) {
    User::AccessToken.fetch_user_id(req.headers["X-AccessToken"]) || 'Guest'
  },
]
