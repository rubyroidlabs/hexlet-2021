# frozen_string_literal: true

require_relative 'checker/printer'
require_relative 'checker/file_loader'
require_relative 'checker/request'
require_relative 'checker/filter_service'

module Checker
  class App
    include FileLoader
    include Printer

    attr_reader :requests

    def initialize(options)
      @options = options
      @requests = { success: [], failed: [], error: [] }

      @filter = FilterService.new(options)
    end

    def run
      hosts = load_file(@options[:file])
      @hosts = @filter.filter_hosts(hosts)

      @options[:parallel] ? process_requests_parallel : process_requests_single_threaded

      print_final_result(@requests)
    end

    private

    def make_request(url)
      request = Request.new(url)
      request.perform

      return unless @filter.selected_content?(request)

      @requests[request.status] << request
      print_result(request)
    end

    def process_requests_single_threaded
      @hosts.each { |url| make_request(url) }
    end

    def process_requests_parallel
      queue = Queue.new
      @hosts.each { |url| queue << url }

      Array.new(@options[:parallel]) do
        Thread.new do
          until queue.empty?
            next_url = queue.pop
            make_request(next_url)
          end
        end
      end.each(&:join)
    end
  end
end
