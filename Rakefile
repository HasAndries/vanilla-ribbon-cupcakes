require 'rubygems'
require "rake"
require "rake/rdoctask"
require "rspec/core/rake_task"
require "rspec/core/version"

#===========================RAKE TASKS=========================
def make_task(name, docs = false, path = 'spec')
  options = ["-c", "-r ./spec/spec_helper.rb"]
  options << "-f progress" if !docs
  options << "-f NiceFormatter" << "-o docs/test_results.htm" << "-r ./spec/nice_formatter.rb" if docs
  pattern = "#{path}/**/*_spec.rb"
  
  RSpec::Core::RakeTask.new(name) do |t|
    t.rspec_opts = options
    t.pattern = pattern
  end
end

make_task(:test)
make_task(:lib,     false, 'spec/lib')
make_task(:app,     false, 'spec/app')
make_task(:doc,     true)

task :default => [:test]

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

task :test_data do
  require './data/test_data'
end