module MessageBus::Client::Configuration
  def self.included(module_)
    module_.extend(ClassMethods)
  end

  module ClassMethods
    def self.extended(module_)
    end
  end
end
