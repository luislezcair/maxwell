# frozen_string_literal: true

if ENV['SENTRY_ACTIVE'] == 'true'
  Raven.configure do |config|
    config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  end
end
