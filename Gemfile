# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
gem 'rails-i18n'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '>= 4.0.x'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Favicon generator
  gem 'rails_real_favicon'

  # gem 'i18n-debug'

  # Use Capistrano for deployment
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
  gem 'capistrano-yarn'
  gem 'capistrano3-puma'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'

  gem 'database_cleaner'
  gem 'factory_bot_rails'

  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'

  gem 'launchy'

  gem 'vcr'
  gem 'webmock'
end

group :production do
  # Sentry.io for reporting errors
  gem 'sentry-raven'
end

# A better rails console
gem 'pry-rails'

# User authentication and authorization
gem 'devise'
gem 'devise-i18n'
gem 'cancancan'

# Better forms
gem 'simple_form'
gem 'enumerize'

# Search forms
gem 'ransack'

# Pagination
gem 'kaminari'

# REST client library
gem 'her'
gem 'faraday_middleware'
gem 'simple_oauth'

gem 'oauth2'

gem 'sidekiq'

# Generate XLSX documents
gem 'axlsx', '3.0.0.pre'

# Define crontab jobs from rails scripts
gem 'whenever', require: false

# Models with tree structure using the materialized path pattern
gem 'ancestry'
