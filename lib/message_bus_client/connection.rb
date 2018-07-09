module MessageBusClient::Connection
  # The connection is in the initialised state.
  INITIALISED = 0

  # The connection is in the started state.
  STARTED = 1

  # The connection is in the paused state.
  PAUSED = 2

  # The connection is in the stopping state.
  STOPPING = 3

  # The connection is in the stopped state.
  STOPPED = 4

  def initialize(base_url)
    @connection = nil
    @runner = nil
    @base_url = base_url
    @state = INITIALISED

    @statistics = { total_calls: 0, failed_calls: 0 }
  end

  def diagnostics
  end

  def start
    return unless @state == INITIALISED || stopped?
    @state = STARTED

    @connection = Excon.new(server_endpoint, persistent: true)
    @runner = Thread.new { runner }
    @runner.abort_on_exception = true
  end

  def pause
    return unless @state == STARTED

    @state = PAUSED
  end

  def paused?
    @state == PAUSED
  end

  def resume
    return unless @state == PAUSED

    @state = STARTED
    handle_messages
  end

  def stop
    return unless @state == STARTED || @state == PAUSED

    @state = STOPPING
    @connection.reset
    @runner.join
  end

  def stopped?
    @state == STOPPED
  end

  private

  # The runner handling polling over the connection.
  def runner
    poll until @state == STOPPING
  rescue Excon::Errors::Error
    @statistics[:failed_calls] += 1
    retry
  ensure
    @state = STOPPED
  end

  # Polls the server for messages.
  def poll
    @statistics[:total_calls] += 1

    response = @connection.post(request_parameters)
    unless MessageBusClient.configuration.long_polling
      handle_connection_response(response)
    end
  end

  # The request parameters when connecting to the server with Excon.
  def request_parameters
    request_body = URI.encode_www_form(subscribed_channel_indices.
                                       merge(__seq: @statistics[:total_calls]))
    request_parameters = { body: request_body, headers: headers, read_timeout: 360 }
    if MessageBusClient.configuration.long_polling
      request_parameters[:response_block] = method(:handle_chunk).to_proc
    end

    request_parameters
  end

  # The headers to send when polling
  def headers
    headers = {}
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
    headers['X-SILENCE-LOGGER'] = 'true'
    unless MessageBusClient.configuration.long_polling
      headers['Dont-Chunk'] = 'true'
    end

    headers
  end

  # Gets the URI to poll the server with
  def server_endpoint
    endpoint = "#{@base_url}/message-bus/#{@client_id}/poll"
    unless MessageBusClient.configuration.long_polling
      endpoint << "?dlp=t"
    end

    endpoint
  end

  # Handles the response from the connection.
  def handle_connection_response(response)
    handle_response(response.body)
    sleep(MessageBusClient.configuration.poll_interval)
  end
end
