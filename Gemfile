source 'https://rubygems.org'

ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

### Additional gems
# Generic syntax highlighter
gem 'pygments.rb', '0.5.4'
# Markdown parser "Redcarpet is Ruby library for Markdown processing that smells like butterflies and popcorn."
gem 'redcarpet', '3.1.1'
gem 'sass-rails', '~> 4.0.1'
# Bootstrap - front-end framework
gem 'bootstrap-sass', '~> 3.1.1'
# Nice bootstrap template generator
gem 'bootstrap-generators', '~> 3.1.1'
# CSS Animation
gem 'animate-scss' # gem 'animate-rails'
# Paginator
gem 'will_paginate', '~> 3.0.5'
gem 'bootstrap-will_paginate', '~> 0.0.10'
# Useful for crypting passwords
# gem 'bcrypt' #gem 'bcrypt-ruby', :require => 'bcrypt'
# Filter scopes
gem 'has_scope', '~> 0.5.1'
# Combobox overlay
gem 'select2-rails', '~> 3.5.4'
# Simplier form syntax
gem 'simple_form', '~> 3.0.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Quiet assets
  gem 'quiet_assets'
end

group :development, :test do
  # Development SQLite3 Database
  gem 'sqlite3', '1.3.9'
  # Tool for testing
  gem 'rspec-rails'
  # Ruby debugger
  # gem 'debugger'
end

group :test do
  # Automated test running
  gem 'guard-rspec', '~> 4.2.9'
  # Testing tool for simulating user interaction with website
  gem 'capybara', '~> 2.2.1'
  # Automatic & easier definition loading
  gem 'factory_girl_rails', '~> 4.4.1'
  # Database cleaner
  gem 'database_cleaner'
  # Helper for Select2 dropdown
  gem 'capybara-select2'
end

group :production do
  gem 'pg', '0.17.1'
  gem 'rails_12factor'
  # Loads Shelly dependencies
  gem 'shelly-dependencies'
end