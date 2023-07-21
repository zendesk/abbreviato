# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'

Bundler::GemHelper.install_tasks

# Pushing to rubygems is handled by a github workflow
ENV['gem_push'] = 'false'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

if %w[development test].include?(ENV['RAILS_ENV'] ||= 'development')
  require 'bundler/audit/task'
  Bundler::Audit::Task.new

  desc 'Analyze for code duplication (large, identical syntax trees) with fuzzy matching.'
  task :flay do
    require 'flay'
    flay = Flay.run(%w[bin config lib script])
    flay.report

    threshold = 0
    raise "Flay total too high! #{flay.total} > #{threshold}" if flay.total > threshold
  end

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  desc 'Analyze security vulnerabilities with brakeman'
  task :brakeman do
    `brakeman --exit-on-warn --exit-on-err --format plain --ensure-latest --table-width 999 --force-scan lib --ignore-config .brakeman.ignore`
  end

  desc 'Run all linters'
  task lint: %w[rubocop flay brakeman]
end

task default: :spec
