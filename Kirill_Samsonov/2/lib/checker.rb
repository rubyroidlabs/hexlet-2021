# frozen_string_literal: true

require 'net/http'
require_relative './file_reader'
require_relative './console_output'
require_relative './formatter'
require_relative './response'
require_relative './filter'
require_relative './domain'

class Checker
  include ConsoleOutput
  include Formatter

  def initialize(source, options)
    @source = source
    @options = options
    @filter = Filter.new(@options)
    @reader = FileReader.new(@source, @options)
  end

  def run
    domain_names = @reader.read
    domains = domain_names.map { |name| Domain.new(name) }
    filtered_domains = @filter.filter_domains(domains)

    summary = check_domains(filtered_domains) do |domain_check_result|
      print format_domain_result(domain_check_result)
    end

    print format_summary(summary)
  end

  def check_domains(domains)
    result = { total: 0, success: 0, failed: 0, errored: 0 }
    domains.each do |domain|
      check_result = domain.check
      response = Response.new(check_result, @options)
      next if response.skip?

      response.success? ? result[:success] += 1 : result[:failed] += 1
      yield ({ domain: domain.name, status: response.code, latency: domain.elapsed_time })
    rescue StandardError => e
      result[:errored] += 1
      yield ({ domain: domain.name, error: true, message: e.message })
    end
    result[:total] = result[:success] + result[:failed] + result[:errored]
    result
  end
end
