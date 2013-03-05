require 'faraday'
require 'uri'
require 'verbose_hash_fetch'
require 'yaml'
require 'json'
require 'forwardable'
require 'fileutils'

module ServiceDouble

  NotRunning = Class.new(Error)
  NotStarted = Class.new(Error)
  Timeout    = Class.new(Error)

  class Manager

    extend Forwardable

    def_delegators :connection, :get, :post, :head, :delete, :put, :patch

    attr_reader :root_url, :log_file, :started_at, :timeout, :server, :name

    def initialize(config)
      @root_url = config.url
      @log_file = config.log_file
      @timeout  = config.timeout
      @server   = config.server
      @name     = config.name
    end

    def start
      FileUtils.mkdir_p(File.dirname(log_file)) if log_file.is_a?(String)
      args = %w(ruby -r sinatra -r json) << server << "-p" << port
      args << { :out => log_file, :err => log_file }
      @pid = Process.spawn(*args)
      @started_at = Time.now
      wait until up?
    end

    def reset
      delete("/")
    end

    def stop
      if started?
        Process.kill("TERM", @pid)
        Process.waitpid(@pid)
      end
    end

    def port
      URI(root_url).port.to_s
    end

    def wait
      unless timed_out?
        sleep 0.01
      else
        raise Timeout, "It took more than #{timeout} seconds to start #{name}. Check the logs at #{log_file} to see why."
      end
    end

    def up?
      started? and running?
    end

    def started?
      if @pid
        Process.getpgid(@pid) rescue false
      else
        raise NotStarted, "The fake #{name} hasn't been started yet."
      end
    end

    def running?
      get("/").status == 200 rescue false
    end

    def timed_out?
      Time.now - timeout > started_at
    end

    def connection
      @connection ||= Faraday.new(url: root_url) { |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      }
    end

  end

end
