# frozen_string_literal: true

require_relative 'file_loader'

module Checker
  class FilterService
    include FileLoader

    def initialize(options)
      @options = options
    end

    def filter_hosts(hosts)
      hosts = hosts.reject { |name| subdomain?(name) } if @options[:no_subdomains]

      if @options[:exclude_solutions]
        @solutions = load_file('solutions.csv')
        hosts = hosts.reject { |name| solution?(name) }
      end

      hosts
    end

    def selected_content?(response)
      if @options[:filter]
        response.status == :error ||
          response.status == :failed ||
          (response.status == :success && response.content&.include?(@options[:filter]))
      else
        true
      end
    end

    private

    def subdomain?(host_name)
      host_name_arr = host_name.split('.')
      (host_name_arr.size >= 3) || (host_name_arr.size == 3 && host_name_arr.first != 'www')
    end

    def solution?(host_name)
      @solutions.any? { |solution| host_name.include?(solution) }
    end
  end
end
