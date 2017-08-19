# frozen_string_literal: true

module MessageBusClient::MessageHandler
  SubscribedChannel = Struct.new(:callbacks, :last_id) do
    def initialize(last_id = -1)
      self.callbacks = []
      self.last_id = last_id
    end

    def callback(payload)
      callbacks.each do |callback|
        callback.call(payload)
      end
    end
  end

  # The chunk separator for chunked messages.
  CHUNK_SEPARATOR = "\r\n|\r\n"

  def initialize(base_url)
    super

    @pending_messages = []
    @subscribed_channels = {}
    @subscribed_channels.default_proc = proc do |hash, key|
      hash[key] = SubscribedChannel.new
    end
    @payload = +''
  end

  def subscribe(channel, &callback)
    @subscribed_channels[channel].callbacks << callback
  end

  def unsubscribe; end

  private

  def subscribed_channel_indices
    result = {}
    @subscribed_channels.each do |channel, subscription|
      result[channel] = subscription.last_id
    end

    result
  end

  def handle_chunk(chunk, _remaining_bytes, _total_bytes)
    @payload << chunk
    try_consume_message
  end

  def handle_response(body)
    handle_messages(JSON.parse(body)) unless body.empty?
  end

  def try_consume_message
    index = @payload.index(CHUNK_SEPARATOR)
    return unless index

    message = @payload[0..index]
    @payload = @payload[(index + CHUNK_SEPARATOR.length)..-1]

    handle_response(message)
  end

  def handle_messages(messages = nil)
    if paused?
      @pending_messages.concat(messages)
    else
      handle_message_method = method(:handle_message)
      @pending_messages.each(&handle_message_method)
      messages.each(&handle_message_method) if messages
    end
  end

  def handle_message(message)
    return handle_status_message(message) if message['channel'] == '/__status'

    subscription = @subscribed_channels[message['channel']]
    return unless subscription

    subscription.last_id = message['message_id']
    subscription.callback(message['data'])
  end

  def handle_status_message(message)
    message['data'].each do |channel, last_id|
      next unless @subscribed_channels.key?(channel)

      @subscribed_channels[channel].last_id = last_id
    end
  end
end
