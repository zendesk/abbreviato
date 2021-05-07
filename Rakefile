# frozen_string_literal: true

require 'bundler/setup'
require 'wwtd/tasks'
require 'bundler/gem_tasks'
require 'bump/tasks'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

if %w[development test].include?(ENV['RAILS_ENV'] ||= 'development')
  def run_command(command)
    result = `#{command}`
    result.force_encoding('binary')
    raise "Command #{command} failed: #{result}" unless $?.success?

    result
  end

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

  task :brakecheck do
    puts 'Running brakecheck...'
    %w[brakecheck brakeman bundler-audit flay rubocop].each do |gem_name|
      result = `brakecheck #{gem_name}`
      result.force_encoding('binary')
      if $?.success?
        puts "✔ #{gem_name}"
      else
        raise "✘ #{gem_name}'s brakecheck failed: #{result}"
      end
    end
    true
  end

  task :brakeman do
    run_command 'brakeman --exit-on-warn --exit-on-err --format plain --ensure-latest --table-width 999 --force-scan lib --ignore-config .brakeman.ignore'
  end
end

task default: :wwtd
