# Service Double

A tool for making fake versions of external (web) services. You can use fake
web services to return predicatable results for testing.

What you need to do is create a small Sinatra application, that will play the
fake version during your tests.

By convention, the application should respond to two basic urls: `GET /` and
`DELETE /`. The GET request is used to tell if the application is running. The
DELETE request should reset the application, and is called between each
test/scenario.

An example of such a fake web service:

``` ruby
values = []

get "/" do
  200
end

delete "/" do
  values.clear
  200
end

post "/remember" do
  values << params[:value]
end

get "/remembered" do
  { :remembered => values }.to_json
end
```

The idea is that inside this fake app, you can cheat all you like. Your
database might be a simple hash or array, or you can choose to return simple
canned responses.

You can also add paths to your fake app that don't exist in the real app, which
you can use for easy testing and debugging.

## Installation

Add this line to your application's Gemfile:

``` ruby
group :test do
  gem 'service_double', require: false
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install service_double

## Usage

To hook it up to a test framework:

``` ruby
require 'service_double'

ServiceDouble.hook_into(:cucumber) do |config|
  config.server = "my_sinatra_server.rb"
  config.url = "http://localhost:12345"
end
```

Supported frameworks are currently `:cucumber` and `:rspec`.

The configuration options are:

* **server** where to find the fake web service app (required)
* **url** where the fake web service should be accessed (required)
* **timeout** how long you allow the fake server to take booting up (default: 2 seconds)
* **log_file** where to write the server logs to (default: "log/#{server}.log")

You can have one or multiple services doubles, and control them:

``` ruby
$widget_service = ServiceDouble.hook_into(:rspec) do |config|
  config.server = "fake_widgets.rb"
  config.url = "http://localhost:12345"
end

$weather_service = ServiceDouble.hook_into(:rspec) do |config|
  config.server = "fake_weather.rb"
  config.url = "http://localhost:12346"
end

# later on:

$weather_service.post("/_stub_temp", :place => "New York", :temp => 22.4)
```

Here are some methods that can be called on the service objects:

* **get** performs a GET request (maps to Faraday's `get` method)
* **post** performs a POST request (like `get`)
* **delete** etc...
* **put** etc...
* **post** etc...
* **reset** sends `DELETE` request to `/` (is done automatically between tests)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
