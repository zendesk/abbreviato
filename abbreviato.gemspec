# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'abbreviato/version'

Gem::Specification.new do |s|
  s.name = 'abbreviato'
  s.version = Abbreviato::VERSION

  s.authors = ['Jorge Manrubia']
  s.description = 'Truncate HTML to a specific bytesize, while keeping valid markup'
  s.email = 'jorge.manrubia@gmail.com'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE.txt', 'Rakefile', 'README.rdoc']
  s.homepage = 'https://github.com/zendesk/abbreviato'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.summary = 'A tool for efficiently truncating HTML strings to a specific bytesize'

  s.required_ruby_version = '>= 3.1'

  s.add_dependency 'htmlentities', '~> 4.3.4'
  s.add_dependency 'nokogiri', '~> 1.18'
end
