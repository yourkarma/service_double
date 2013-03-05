require "service_double/version"

module ServiceDouble

  Error = Class.new(StandardError)
  UnknownFramework = Class.new(Error)

  require "service_double/manager"
  require "service_double/configuration"

  def self.hook_into(framework, &block)
    require_relative "service_double/frameworks/#{framework}"
    config = Configuration.new
    yield config
    manager = Manager.new(config)
    managers << manager
    manager
  rescue LoadError
    raise UnknownFramework, "No hooks provided for #{framework.inspect}."
  end

  def self.managers
    @managers ||= []
  end

  def self.start
    managers.each(&:start)
  end

  def self.stop
    managers.each(&:stop)
  end

  def self.reset
    managers.each(&:reset)
  end

end
