RSpec.configure do |config|

  config.before(:suite) do
    ServiceDouble.start
  end

  config.before(:each) do
    ServiceDouble.reset
  end

  config.after(:suite) do
    ServiceDouble.stop
  end

end
