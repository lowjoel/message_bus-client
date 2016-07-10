require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :server do
  pid = 0
  Bundler.with_clean_env do
    pid = spawn "bundle exec puma 'spec/chat_server.ru'"
  end

  at_exit do
    $stderr.puts "Killing pid #{pid}"
    Process.kill('KILL', pid)
    Process.wait(pid)
  end

  sleep 3
end

task :spec => :server

task default: :spec
