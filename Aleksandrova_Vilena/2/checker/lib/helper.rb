# frozen_string_literal: true

require 'optparse'
require 'csv'
require 'logger'
require 'yaml'

##
class ArgsParser
  # @param [Object] args
  def self.parse(args)
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: Ping Util'
      opts.on('-n', '--no-subdomains') { |o| options[:subdomains] = o }
      opts.on('-f', '--filter KEYWORD') { |o| options[:filter] = o }
      opts.on('-r', '--exclude-solutions') { |o| options[:opensource] = o }
      opts.on('-p', '--parallel N') { |o| options[:parallel] = o }
      opts.parse!(args)
    end
    options
  end
end

##
module CsvParser
  attr_reader :data

  # @param [Object] file_path
  def initialize_csv(file_path, _options)
    @data = CSV.read(file_path).map(&:join)
  end

  # @param [Object] options
  def filter(options)
    logger.debug "filtering with options: #{options}"
    @data = data.reject { |k| k.count('.') > 1 } if options.key?(:subdomains)
    @data = filter_opensource(options, @data) if options.key?(:opensource)
  end

  def filter_opensource(options, data)
    open_source_data = Config.get('OpenSource').map(&:downcase)
    data -= data.select do |x|
      open_source_data.find { |t| x.include?(t) }
    end
    data
  end
end

##
module Logging
  class << self
    def logger
      @logger ||= Logger.new($stdout)
    end

    attr_writer :logger
  end

  def self.included(base)
    class << base
      def logger
        Logging.logger
      end
    end
  end

  def logger
    Logging.logger
  end
end

##
class Config
  CONFIG_FILE = 'config.yaml'
  class << self
    def get(key)
      config[key.to_s]
    end

    def config
      @config ||= YAML.safe_load(File.read(file_path))
    end

    def file_path
      File.join(File.expand_path('..', __dir__), 'config', CONFIG_FILE.to_s)
    end
  end
end

class Output
end
