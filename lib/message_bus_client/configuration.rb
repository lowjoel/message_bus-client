# frozen_string_literal: true

module MessageBusClient::Configuration
  def self.included(module_)
    module_.extend(ClassMethods)
  end

  module ClassMethods
    attr_accessor :long_polling
    attr_accessor :poll_interval

    def self.extended(module_)
      module_.long_polling = true
      module_.poll_interval = 15
    end
  end
end
