# MessageBus::Client
[![Build Status](https://travis-ci.org/lowjoel/message_bus-client.svg?branch=master)](https://travis-ci.org/lowjoel/message_bus-client)[![Coverage Status](https://coveralls.io/repos/github/lowjoel/message_bus-client/badge.svg?branch=master)](https://coveralls.io/github/lowjoel/message_bus-client?branch=master)[![Code Climate](https://codeclimate.com/github/lowjoel/message_bus-client/badges/gpa.svg)](https://codeclimate.com/github/lowjoel/message_bus-client)[![security](https://hakiri.io/github/lowjoel/message_bus-client/master.svg)](https://hakiri.io/github/lowjoel/message_bus-client/master)[![Inline docs](http://inch-ci.org/github/lowjoel/message_bus-client.svg?branch=master)](http://inch-ci.org/github/lowjoel/message_bus-client)

This is a Ruby implementation of the client for
[message_bus](https://github.com/samsaffron/message_bus).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'message_bus-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install message_bus-client

## Usage

The API is mostly equivalent with the JavaScript client:

```ruby
client = MessageBus::Client.new('http://chat.samsaffron.com/')
client.subscribe('/message') do |payload|
  # Do stuff
end

client.start
client.pause
client.resume
client.stop
```

Both Long Polling and normal polling are supported:

```ruby
MessageBus::Client.long_polling = true # false to disable
MessageBus::Client.poll_interval = 15 # seconds
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to
run the tests.

If you are running Windows, Ruby is not able to kill the server process. Run it separately using
`rake server` before running the specs.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/lowjoel/message_bus-client.

