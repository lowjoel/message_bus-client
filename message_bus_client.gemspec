# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'message_bus_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'message_bus_client'
  spec.version       = MessageBusClient::VERSION
  spec.authors       = ['Joel Low']
  spec.email         = ['joel@joelsplace.sg']

  spec.summary       = 'Ruby client for Message Bus'
  spec.description   = 'Implements a client for Message Bus, with communication over HTTP'
  spec.homepage      = 'https://github.com/lowjoel/message_bus_client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").
                       reject { |f| f.match(/^(test|spec|features)\//) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'codeclimate-test-reporter'

  # These dependencies are for running the Chat server locally.
  spec.add_development_dependency 'message_bus'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'sinatra'

  spec.add_dependency 'excon', '~> 0.45'
end
