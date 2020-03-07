ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require File.expand_path('../config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rails_helper'
require 'rspec/rails'
require 'factory_bot_rails'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Dir[Rails.root.join("spec/support/*.rb")].each {|f| require f }

shared_context "stub_current_user" do
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end
end
