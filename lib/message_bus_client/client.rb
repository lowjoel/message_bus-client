require 'message_bus_client/connection'
require 'message_bus_client/message_handler'

module MessageBusClient
  class Client

    include MessageBusClient::Connection
    include MessageBusClient::MessageHandler

    def initialize(base_url)
      super
      @client_id = SecureRandom.uuid
    end

  end
end
