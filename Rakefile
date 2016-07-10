require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :server do
  Bundler.with_clean_env do
    sh "bundle exec puma 'spec/chat_server.ru'"
  end
end

task default: :spec
