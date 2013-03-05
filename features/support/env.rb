require 'bundler/setup'
Bundler.setup

require 'service_double'
require 'json'

$cucumber_server = ServiceDouble.hook_into :cucumber do |config|
  config.server = File.expand_path("../../../spec/support/rspec_server.rb", __FILE__)
  config.url = "http://localhost:8083"
end
