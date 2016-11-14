$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'bundler'
require 'nokogiri'
require 'abbreviato'
require 'html_abbreviator'
require 'peppercorn'
require 'benchmark'

Bundler.setup
Bundler.require

Dir[File.dirname(__FILE__) + '/abbreviato/**/*.rb'].each do |file|
  load file
end
