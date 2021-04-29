# frozen_string_literal: true

require_relative 'checker/version'
require_relative 'checker/parse_csv'
require_relative 'checker/request'
require_relative 'checker/print'
require_relative 'checker/filter'

module Cli
  class Error < StandardError; end

  class App
    include ParseCSV

    def initialize(options)
      @options = options
      @data = []
      @hosts = parse_csv(options[:file])
      @printer = Checker::Print.new
      @filter = Checker::Filter.new(options)
    end

    def run
      @hosts = @filter.filter_hosts(@hosts)
      parallel? ? perform_parallel : bulk_requests(@hosts)
      @printer.console_print(@printer.to_s)
    end

    def bulk_requests(hosts)
      hosts.each do |e|
        r = Checker::Request.new(e)
        r.get
        @printer.logger(r) unless skip?(r)
      end
    end

    def perform_parallel
      chunk_size = @hosts.size / @options[:parallel] + 1
      threads = []
      @hosts.each_slice(chunk_size) do |chunk|
        threads << Thread.new(chunk) do |c|
          bulk_requests(c)
        end
      end
      threads.each(&:join)
    end

    def parallel?
      !@options[:parallel].nil?
    end

    def skip?(res)
      @filter.filter_word(res)
    end
  end
end
