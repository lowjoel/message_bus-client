# frozen_string_literal: true

module MessageBusClient::Connection
  # The connection is in the initialised state.
  INITIALISED = :initialised

  # The connection is in the started state.
  STARTED = :started

  # The connection is in the paused state.
  PAUSED = :paused

  # The connection is in the stopping state.
  STOPPING = :stopping

  # The connection is in the stopped state.
  STOPPED = :stopped

  def initialize(base_url)
    @connection = nil
    @runner = nil
    @base_url = base_url
    @state = INITIALISED

    @statistics = { total_calls: 0, failed_calls: 0 }
  end

  def diagnostics; end

  def start(**options)
    return unless @state == INITIALISED || stopped?

    @connection = Excon.new(server_endpoint, persistent: true, **options)

    @runner = Thread.new(&method(:runner))
    @runner.name = "MessageBusClient (#{@client_id})"
    @runner.abort_on_exception = true

    @state = STARTED
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

  def stop(timeout = nil)
    fail ThreadError if Thread.current == @runner

    return if should_stop? || stopped?

    @state = STOPPING
    @connection.reset

    wakeup # break out of light sleep when polling

    unless @runner.join(timeout)
      @runner.kill
      @runner.join # just killing the thread is not enough to finish the work
    end

    @runner.stop?
  end

  def stopped?
    @state == STOPPED
  end

  private

  def should_stop?
    @state == STOPPING
  end

  # The runner handling polling over the connection.
  def runner
    poll until should_stop?
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
    handle_connection_response(response) unless self.class.long_polling
  end

  # The request parameters when connecting to the server with Excon.
  def request_parameters
    request_body = URI.encode_www_form(subscribed_channel_indices.
                                       merge(__seq: @statistics[:total_calls]))
    request_parameters = { body: request_body, headers: headers, read_timeout: 360 }
    request_parameters[:response_block] = method(:handle_chunk).to_proc if self.class.long_polling

    request_parameters
  end

  # The headers to send when polling
  def headers
    headers = {}
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
    headers['X-SILENCE-LOGGER'] = 'true'
    headers['Dont-Chunk'] = 'true' unless self.class.long_polling

    headers
  end

  # Gets the URI to poll the server with
  def server_endpoint
    endpoint = +"#{@base_url}/message-bus/#{@client_id}/poll"
    endpoint << '?dlp=t' unless self.class.long_polling

    endpoint.freeze
  end

  def light_sleep(seconds)
    return if should_stop?
    @_sleep_check, @_sleep_interrupt = IO.pipe
    IO.select([@_sleep_check], nil, nil, seconds)
  end

  def wakeup
    @_sleep_interrupt.close if defined?(@_sleep_interrupt) && !@_sleep_interrupt.closed?
  end

  # Handles the response from the connection.
  def handle_connection_response(response)
    handle_response(response.body)
    light_sleep(self.class.poll_interval)
  end
end
