$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
require 'nokogiri'

Bundler.setup
Bundler.require

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.extend TruncatoMacros
end

RSpec::Matchers.define :be_valid_html do
  match do |actual|
    # Fires exception
    Nokogiri::HTML("<html><body>#{actual}</body></html>", &:strict)
    true
  end
end
