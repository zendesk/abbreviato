# frozen_string_literal: true

require 'nokogiri'
require 'rspec-benchmark'
require 'benchmark/memory'
require 'abbreviato'

require_relative 'support/spec_helpers/abbreviato_macros'

RSpec.configure do |config|
  config.extend AbbreviatoMacros
  config.include RSpec::Benchmark::Matchers
end

RSpec::Matchers.define :be_valid_html do
  match do |actual|
    # Fires exception
    Nokogiri::HTML("<html><body>#{actual}</body></html>", &:strict)
    true
  end
end
