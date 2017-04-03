require 'bundler/setup'
require 'wwtd/tasks'
require 'bundler/gem_tasks'
require 'bump/tasks'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'bundler/audit/task'
Bundler::Audit::Task.new

task default: :wwtd
