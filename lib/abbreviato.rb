# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/abbreviato/**/*.rb"].sort.each do |file|
  require file
end
