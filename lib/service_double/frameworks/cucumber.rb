AfterConfiguration do |config|
  ServiceDouble.start
end

Before do
  ServiceDouble.reset
end

at_exit do
  ServiceDouble.stop
end
