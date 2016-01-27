# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'message_bus/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'message_bus-client'
  spec.version       = MessageBus::Client::VERSION
  spec.authors       = ['Joel Low']
  spec.email         = ['joel@joelsplace.sg']

  spec.summary       = 'Ruby client for Message Bus'
  spec.description   = 'Implements a client for Message Bus, with communication over HTTP'
  spec.homepage      = 'https://github.com/lowjoel/message_bus-client'

  spec.files         = `git ls-files -z`.split("\x0").
                       reject { |f| f.match(/^(test|spec|features)\//) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
