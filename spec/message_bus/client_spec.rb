describe MessageBus::Client do
  it 'has a version number' do
    expect(MessageBus::Client::VERSION).not_to be nil
  end

  def write_message(message, user = 'message_bus-client')
    Excon.post('http://chat.samsaffron.com/message',
               body: URI.encode_www_form(name: user, data: message),
               headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
  end

  subject { MessageBus::Client.new('http://chat.samsaffron.com') }

  context 'when using long polling' do
    it 'connects to the server' do
      subject.start
      subject.stop
    end

    context 'when the connection times out' do
      it 'continues to long poll' do
        count = 0
        expect(subject).to receive(:request_parameters).and_wrap_original do |original, *args|
          count += 1
          parameters = original.call(*args)
          parameters[:read_timeout] = 0

          parameters
        end.at_least(:twice)

        subject.start
        sleep(1) until count > 1

        subject.stop
      end
    end

    it 'receives messages' do
      subject.start

      message = 'Hello World!'
      result = false
      subject.subscribe('/message') do |payload|
        expect(payload['data']).to eq(message)
        result = true
      end

      until result
        write_message(message) # Keep writing because the message bus might not have started.
        sleep(1)
      end
    end
  end

  context 'when using polling' do
    around(:each) do |example|
      begin
        old_long_polling = MessageBus::Client.long_polling
        MessageBus::Client.long_polling = false
        example.call
      ensure
        MessageBus::Client.long_polling = old_long_polling
      end
    end

    it 'connects to the server' do
      subject.start
      subject.stop
    end

    it 'receives messages' do
      subject.start

      message = 'Hello World!'
      result = false
      subject.subscribe('/message') do |payload|
        expect(payload['data']).to eq(message)
        result = true
      end

      until result
        write_message(message) # Keep writing because the message bus might not have started.
        sleep(1)
      end
    end
  end
end
