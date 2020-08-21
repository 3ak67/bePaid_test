# # spec/spec_helper.rb

require 'rack/test'
require 'rspec'
require 'factory_bot'
require 'database_cleaner/active_record'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.formatter = :documentation
  config.tty = true
  config.color = true

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # config.before(:each) do
  #   DatabaseCleaner.strategy = :transaction
  #   DatabaseCleaner.start
  # end
  #
  # config.before(:each, :js => true) do
  #   DatabaseCleaner.strategy = :truncation
  # end
  #
  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end

end