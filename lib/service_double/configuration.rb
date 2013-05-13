module ServiceDouble

  NoURLSet   = Class.new(Error)
  NoServerSet = Class.new(Error)
  ServerNotFound = Class.new(Error)

  class Configuration

    attr_accessor :url, :log_file, :timeout, :server, :disable_bundler

    def initialize
      @url = nil
      @server = nil
      @log_file = nil
      @timeout = 5
      @disable_bundler = true
    end

    def url
      @url || no_url_set!
    end

    def server=(path)
      full = File.expand_path(path)
      if File.exist?(full)
        @server = full
      else
        raise ServerNotFound, "Cannot find server to run at #{full}"
      end
    end

    def server
      @server || no_server_set!
    end

    def log_file
      @log_file || "log/#{name}.log"
    end

    def name
      File.basename(server, ".rb")
    end

    def no_url_set!
      raise NoURLSet, "No URL set for the fake shop."
    end

    def no_server_set!
      raise NoServerSet, "No server option set."
    end

  end
end
