require 'excon'
require 'json'
require "securerandom"

require 'message_bus/client/version'
require 'message_bus/client/configuration'
require 'message_bus/client/connection'
require 'message_bus/client/message_handler'

class MessageBus::Client
  include MessageBus::Client::Configuration
  include MessageBus::Client::Connection
  include MessageBus::Client::MessageHandler

  def initialize(base_url)
    super
    @client_id = SecureRandom.uuid
  end
end
