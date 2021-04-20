# frozen_string_literal: true

require 'optparse'
require 'csv'
require 'net/http'

class Parser
  attr_reader :options, :args

  def initialize(&block)
    @options = {}
    @args = []
    @opt_parser = OptionParser.new(&block)
  end

  def parse!
    @opt_parser.parse!(into: @options)
    @args = @opt_parser.instance_variable_get(:@default_argv)
  end

  def to_s
    @opt_parser.to_s
  end

  def usage
    to_s
  end
end


class DomainsList
  attr_reader :list

  def initialize(filename, params)
    @list = CSV.read(filename).map(&:first)

    if params[:'no-subdomains']
      reject_subdomains!
    end

    if params[:'exclude-solutions']
      reject_solutions!
    end
  end

  private

  def reject_subdomains!
    @list.filter!  { |domain| domain.count('.') == 1 }
  end

  def reject_solutions!
    @list.filter! do |domain|
      !domain.match(/(\bgitlab\b|\bredmine\b|\bgit\b|\brepo\b|\brm\b|\bsource\b|\bsvn\b)/)
    end
  end
end


class DomainChecker
  attr_reader :domain, :code, :response_time, :body, :status

  def initialize(domain)
    @uri = URI("https://#{domain}/")
    @domain = domain
  end

  def check!
    begin
      start_time = Time.now
      response = Net::HTTP.get_response(@uri)
      end_time = Time.now
      @response_time = "#{((end_time - start_time) * 1000).round}ms"
      @code = response.code
      @body = response.body
      @status = :success
    rescue SocketError => e
      @status = :failure
      @error_message = "ERROR (#{e.cause})"
    end
    self
  end

  def to_s
    case @status
    when :success
      "#{@domain} - #{@code} (#{@response_time})"
    when :failure
      "#{domain} - #{error_message}"
    end
  end
end
