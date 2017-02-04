require 'rake'
require 'rspec/core/rake_task'
require 'bundler/setup'

task :serverspec => 'serverspec:all'
task :default => :serverspec

namespace :serverspec do
  desc 'Run Serverspec tests for `base`'
  RSpec::Core::RakeTask.new('base') do |t|
    t.pattern = 'spec/base_spec.rb'
    t.verbose = true
  end
end
