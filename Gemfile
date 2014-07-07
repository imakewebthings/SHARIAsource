source 'https://rubygems.org'
ruby '2.0.0'

gem 'autoprefixer-rails', '~> 2.1.0'
gem 'devise', '~> 3.2.4'
gem 'foreman', '~> 0.74.0'
gem 'jquery-rails', '~> 3.1.1'
gem 'pg', '~> 0.17.1'
gem 'rack-timeout', '~> 0.0.4'
gem 'rails', '4.1.2'
gem 'simple_form', '~> 3.0.2'
gem 'slim-rails', '~> 2.1.5'
gem 'turbolinks', '~> 2.2.2'
gem 'unicorn', '~> 4.8.0'

group :development do
  gem 'annotate', '~> 2.6.5'
  gem 'guard-livereload', '~> 2.3.0'
  gem 'quiet_assets', '~> 1.0.3'
  gem 'rack-livereload', '~> 0.3.15'
  gem 'spring', '~> 1.1.3'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
  gem 'rspec-rails', '~> 3.0.1'
  gem 'spring-commands-rspec', '~> 1.0.2'
end

group :test do
  gem 'capybara', '~> 2.3.0'
  gem 'guard-rspec', '~> 4.2.10'
  gem 'shoulda-matchers', '~> 2.6.1'
end

group :assets do
  gem 'coffee-rails', '~> 4.0.0'
  gem 'sass-rails', '~> 4.0.3'
  gem 'uglifier', '>= 1.3.0'
end
