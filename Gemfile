source "https://rubygems.org"
gemspec

# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.

# Required for cleaning up a string which has been bytesliced
# https://github.com/hsbt/string-scrub
gem 'string-scrub', git: "https://github.com/arjun-urs/string-scrub.git"

group :development do
  gem "bundler"
  gem 'rubocop', require: false
  gem 'brakeman', require: false
end

group :benchmark do
  gem 'html_truncator'
  gem 'peppercorn'
end
