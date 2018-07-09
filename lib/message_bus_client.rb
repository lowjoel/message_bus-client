require "gem_config"
require 'excon'
require 'json'
require "securerandom"

require 'message_bus_client/client'
require 'message_bus_client/version'

module MessageBusClient
  DEFAULT_LONG_POLLING = true
  DEFAULT_POLL_INTERVAL = 15

  include GemConfig::Base

  with_configuration do
    has :long_polling, values: [true, false], default: DEFAULT_LONG_POLLING
    has :poll_interval, classes: Integer, default: DEFAULT_POLL_INTERVAL
  end

  def self.long_polling
    self.configuration.long_polling
  end

  def self.long_polling=(v)
    self.configuration.long_polling = v
  end

  def self.poll_interval
    self.configuration.poll_interval
  end

  def self.poll_interval=(v)
    self.configuration.poll_interval = v
  end

  def self.new(*opts)
    Client.new(*opts)
  end
end
