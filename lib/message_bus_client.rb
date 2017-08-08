require 'excon'
require 'json'
require 'securerandom'

require 'message_bus_client/version'
require 'message_bus_client/configuration'
require 'message_bus_client/connection'
require 'message_bus_client/message_handler'

class MessageBusClient
  include MessageBusClient::Configuration
  include MessageBusClient::Connection
  include MessageBusClient::MessageHandler

  def initialize(base_url)
    super
    @client_id = SecureRandom.uuid
  end
end
