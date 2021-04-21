# frozen_string_literal: true

require_relative 'checker/printer'
require_relative 'checker/request'
require_relative 'checker/file_loader'

module Checker
  class App
    include FileLoader

    attr_reader :requests

    def initialize(options)
      @options = options

      @requests = Hash.new { |hash, key| hash[key] = [] }
      @printer = Printer.new
    end

    def run
      load_hosts

      if @options[:parallel]
        process_requests_parallel
      else
        process_requests
      end

      @printer.final_result(@requests)
    end

    private

    def load_hosts
      hosts = load_file(@options[:file])

      hosts = hosts.reject { |name| subdomain?(name) } if @options[:no_subdomains]

      if @options[:exclude_solutions]
        @solutions = load_file('solutions.csv')
        hosts = hosts.reject { |name| solution?(name) }
      end

      @hosts = hosts
    end

    def request(url)
      request = Request.new(url)

      return unless selected?(request)

      @requests[request.status] << request
      @printer.print_result(request)
    end

    def process_requests
      @hosts.each { |url| request(url) }
    end

    def process_requests_parallel
      queue = Queue.new
      @hosts.each { |url| queue << url }

      Array.new(@options[:parallel]) do
        Thread.new do
          until queue.empty?
            next_url = queue.pop
            request(next_url)
          end
        end
      end.each(&:join)
    end

    def selected?(response)
      if @options[:filter]
        response.error? || response.failed? || (response.success? && response.content&.include?(@options[:filter]))
      else
        true
      end
    end

    def subdomain?(host_name)
      host_name_arr = host_name.split('.')
      (host_name_arr.size >= 3) || (host_name_arr.size == 3 && host_name_arr.first != 'www')
    end

    def solution?(host_name)
      @solutions.any? { |solution| host_name.include?(solution) }
    end
  end
end
