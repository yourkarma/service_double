When /^I ask the fake server to remember "(.*?)"$/ do |value|
  $cucumber_server.post("/remember", :value => value)
end

Then /^the fake server remembered to "(.*?)"$/ do |value|
  remembered = JSON.parse($cucumber_server.get("/remembered").body)
  remembered.should eq "remembered" => [value]
end

When /^I am in a new scenario$/ do
  # noop
end

Then /^the fake server should remember nothing from the previous scenario$/ do
  remembered = JSON.parse($cucumber_server.get("/remembered").body)
  remembered.should eq "remembered" => []
end
