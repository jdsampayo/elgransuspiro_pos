# frozen-string-literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails-erd', require: false, group: :development

gem 'coffee-rails', '~> 5.0'
gem 'dotenv-rails', '~> 2.7.6', require: 'dotenv/rails-now'
gem 'http'
gem 'jbuilder', '~> 2.10'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.3'
gem 'sass-rails', '~> 6.0.0'
gem 'sidekiq'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 3.33'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'selenium-webdriver'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.3'
  gem 'web-console', '>= 3.3.0'
  gem 'webdack-uuid_migration'
end

gem 'bootstrap', '~> 4.4.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

gem 'discard', '~> 1.2'

gem 'plutus', github: 'jdsampayo/plutus', branch: 'ruby_2_7_1'

# Frontend
gem 'active_link_to'
gem 'auto_strip_attributes', '~> 2.6'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap4-kaminari-views'
gem 'chartkick'
gem 'cocoon'
gem 'data-confirm-modal'
gem 'font-awesome-sass', '~> 5.12.0'
gem 'groupdate'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'ransack', '~> 2.3.2'
gem 'simple_form', '~> 5.0.2'
gem 'slim-rails'
gem 'timecop'

# Printing
gem 'chunky_png'
gem 'escpos'
gem 'escpos-image'
gem 'escper'
gem 'rmagick', '~> 4.1.2', require: false

# Auth
gem 'authlogic', '~> 6.1.0'
gem 'bcrypt', '~> 3.1.13'
gem 'cancancan', '~> 3.1'
gem 'scrypt', '3.0.7'

# Production
gem 'unicorn'
