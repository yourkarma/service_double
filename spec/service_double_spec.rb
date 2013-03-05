require 'service_double'
require 'json'

$rspec_server = ServiceDouble.hook_into :rspec do |config|
  config.server = File.expand_path("../support/rspec_server.rb", __FILE__)
  config.url = "http://localhost:8082"
end

describe ServiceDouble do

  it "should be running" do
    $rspec_server.should be_running
  end

  it "should receive requests" do
    value = rand(10**26).to_s(26)
    $rspec_server.post("/remember", value: value)
    values = JSON.parse($rspec_server.get("/remembered").body)
    values.should eq "remembered" => [value]
  end

  it "should not remember request from the previous test" do
    values = JSON.parse($rspec_server.get("/remembered").body)
    values.should eq "remembered" => []
  end

end
