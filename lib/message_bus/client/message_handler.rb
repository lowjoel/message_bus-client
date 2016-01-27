module MessageBus::Client::MessageHandler
  def initialize(base_url)
    super

    @subscribed_channels = {}
  end

  def subscribe
  end

  def unsubscribe
  end

  private

  def handle_chunk(chunk, remaining_bytes, total_bytes)
    chunk
  end

  def handle_response(body)
    body
  end

  def handle_message(message)

  end
end
