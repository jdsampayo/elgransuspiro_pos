source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails-erd', require: false, group: :development

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0.7'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'dotenv-rails', '~> 2.4.0', require: 'dotenv/rails-now'
gem 'http'
gem 'sidekiq'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'pry'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'webdack-uuid_migration'
  gem 'annotate'
end

gem 'bootstrap', '~> 4.0.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

gem 'simple_form', '~> 4.1.0'
gem 'slim-rails'
gem 'jquery-rails'
gem 'cocoon'
gem 'paranoia', '~> 2.4.1'
gem 'font-awesome-sass', '~> 5.0.9'
gem 'active_link_to'
gem 'auto_strip_attributes', '~> 2.4'
gem 'ransack', '~> 2.1.0'
gem 'groupdate'
gem 'chartkick'
gem 'timecop'
gem 'kaminari'
gem 'bootstrap4-kaminari-views'
gem 'jquery-ui-rails'
gem 'bootstrap-datepicker-rails'
gem 'plutus', github: "jdsampayo/plutus", branch: "fix_rails_5_assets"

# Printing
#gem 'chunky_png'
#gem 'escpos'
#gem 'escpos-image'
gem 'escper'

# Auth
gem 'authlogic'
gem 'bcrypt', '~> 3.1.7'
gem 'scrypt', '1.2.1'
gem 'cancancan', '~> 2.0'

# Production
gem 'unicorn'

gem 'data-confirm-modal'
