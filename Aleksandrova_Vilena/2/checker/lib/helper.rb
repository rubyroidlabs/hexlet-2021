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
      opts.banner = 'Usage: Ping util'
      opts.on('-n', '--no-subdomains', 'Subdomain filter') do |o|
        options[:subdomains] = o
      end
      opts.on('-f', '--filter PARAMETER', 'Parameter filter') do |o|
        options[:filter] = o
      end
      opts.on('-r', '--exclude-solutions', 'Opensource filter') do |o|
        options[:opensource] = o
      end
      opts.on('-p', '--parallel N', 'Paralleling calculation') do |o|
        options[:parallel] = o
      end
      opts.on_tail('-h', '--help', 'Help') do
        puts opts
        exit
      end
    end.parse!(ARGV)
    begin
      opts.parse(args)
    rescue StandardError => e
      puts "Error while parsing args: #{e}"
    end
    options
  end
end

##
module CsvParser
  attr_reader :data

  # @param [Object] file_path
  # @param [Hash] options
  def initialize_csv(file_path, options={})
    logger.info 'reading csv'
    @data = CSV.read(file_path).map(&:join)
  end

  # @param [Object] options
  def filter(options)
    logger.debug "filtering with options: #{options}"
    @data = data.reject { |k| k.count('.') > 1 } if options.key?(:subdomains)
    open_source_data = Config.get('OpenSource').map(&:downcase)
    if options.key?(:opensource)
      @data -= data.select do |x|
        open_source_data.find { |t| x.include?(t) }
      end
    end
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
      File.join(File.expand_path("..", __dir__), 'config', CONFIG_FILE.to_s)
    end
  end
end

class Output
end
