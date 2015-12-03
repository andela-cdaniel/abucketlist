source "https://rubygems.org"

ruby "2.2.3"

gem "rails", "4.2.4"

gem "rails-api"
gem "bcrypt"
gem "jwt"
gem "figaro"

gem "coveralls", require: false

gem "active_model_serializers"

group :development, :test do
  gem "rspec-rails"
  gem "rspec_api_helpers"
  gem "pry"
  gem "pry-rails"
end

group :development do
  gem "sqlite3"
  gem "spring"
end

group :production do
  gem "pg",             "0.17.1"
  gem "rails_12factor", "0.0.2"
end
