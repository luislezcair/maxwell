# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('Rails is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'
require 'support/factory_bot'
require 'vcr'

CHROMIUM_PATH = '/usr/bin/chromium'

if ENV['TRAVIS_ENV'] == '1'
  Capybara.default_driver = :selenium_chrome_headless
else
  Capybara.default_driver = :selenium_chrome

  Selenium::WebDriver::Chrome.path = CHROMIUM_PATH if File.exist?(CHROMIUM_PATH)
  Webdrivers.cache_time = 86_400
end

Capybara.default_max_wait_time = 5

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true

  config.filter_sensitive_data('<UCRM_APP_KEY>') do
    Rails.application.credentials[:ucrm][UCRM_ENV][:api_key]
  end

  config.filter_sensitive_data('<CONTABILIUM_CREDENTIALS>') do
    credentials = Rails.application.credentials[:contabilium][CONTABILIUM_ENV]

    client_id = credentials[:client_id]
    client_secret = credentials[:client_secret]

    { client_id: client_id,
      client_secret: client_secret,
      grant_type: 'client_credentials' }.to_query
  end

  # Permitir que webdrivers instale el driver de chrome durante los tests
  config.ignore_hosts 'chromedriver.storage.googleapis.com'
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Warden::Test::Helpers

  config.include ClientsHelper

  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end
