# MessageBusClient
[![Build Status](https://travis-ci.org/bloom-solutions/message_bus_client.svg?branch=master)](https://travis-ci.org/bloom-solutions/message_bus_client)

This is a fork of [lowjoel's](https://github.com/lowjoel/message_bus-client) [message_bus-client](https://github.com/lowjoel/message_bus-client) with improvements we've been wanting to merge in. Because that repository is no longer active, this gem has been released as `message_bus_client`.

This is a Ruby implementation of the client for [message_bus](https://github.com/samsaffron/message_bus).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'message_bus_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install message_bus_client

## Upgrading from `MessageBus::Client`

1) Change `Gemfile` `gem "message_bus-client"` to `gem "message_bus_client"`
2) Change configuration:
  - `MessageBus.long_polling = true` to `MessageBusClient.configuration.long_polling = true`
  - `MessageBus.poll_interval = 15` to `MessageBusClient.configuration.poll_interval = 15`
  - or...

  ```ruby
  MessageBusClient.configure do |c|
    c.long_polling = true
    c.poll_interval = 15
  end
  ```
3) Change calls to `MessageBus::Client.new` to `MessageBusClient.new`

## Usage

The API is mostly equivalent with the JavaScript client:

```ruby
client = MessageBusClient.new('http://chat.samsaffron.com/')
client.subscribe('/message') do |payload, message_id|
  # Do stuff
end

client.start
client.pause
client.resume
client.stop
```

Both Long Polling and normal polling are supported:

```ruby
MessageBusClient.configure do |c|
  c.long_polling = true # false to disable
  c.poll_interval = 15 # seconds
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to
run the tests.

If you are running Windows, Ruby is not able to kill the server process. Run it separately using
`rake server` before running the specs.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/bloom-solutions/message_bus_client.

## MIT License

Released under MIT License.
