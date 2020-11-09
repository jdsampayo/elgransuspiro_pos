# frozen-string-literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Base
gem 'coffee-rails', '~> 5.0'
gem 'discard', '~> 1.2'
gem 'dotenv-rails', '~> 2.7.6', require: 'dotenv/rails-now'
gem 'http'
gem 'jbuilder', '~> 2.10'
gem 'kaminari'
gem 'pg', '>= 0.18', '< 2.0'
gem 'plutus', '~> 0.17'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.0.3'
gem 'ransack', '~> 2.3.2'
gem 'sass-rails', '~> 6.0.0'
gem 'simple_form', '~> 5.0.3'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 3.33'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'selenium-webdriver'
  gem 'timecop'
end

group :development do
  gem 'annotate'
  gem 'rails-erd', require: false
  gem 'listen', '>= 3.0.5', '< 3.3'
  gem 'web-console', '>= 3.3.0'
  gem 'webdack-uuid_migration'
end

# Frontend
gem 'active_link_to'
gem 'auto_strip_attributes', '~> 2.6'
gem 'bootstrap', '~> 4.5.3'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap4-kaminari-views'
gem 'chartkick'
gem 'cocoon'
gem 'data-confirm-modal'
gem 'font-awesome-sass', '~> 5.15.1'
gem 'groupdate'
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Auth
gem 'authlogic', '~> 6.2.0'
gem 'bcrypt', '~> 3.1.16'
gem 'cancancan', '~> 3.1'
gem 'scrypt', '3.0.7'

# Deployment
gem 'unicorn'
gem 'sidekiq'

