require 'excon'
require 'json'
require "securerandom"

require 'message_bus_client/client'
require 'message_bus_client/version'

module MessageBusClient
  def self.new(*opts)
    Client.new(*opts)
  end
end
