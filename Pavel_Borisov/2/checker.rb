# frozen_string_literal: true

require 'optparse'
require 'csv'
require 'net/http'

params = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options] FILENAME"
  opts.on('--no-subdomains', 'Exclude entries with subdomains', TrueClass)
  opts.on('--filter=WORD', 'Filter out results containing WORD in page body', String)
  opts.on('--exclude-solutions', 'Exclude common open-source solutions', TrueClass)
end.parse!(into: params)

domain_list_filename = ARGV.first

unless !domain_list_filename.nil? && File.exists?(domain_list_filename)
  fail(ArgumentError, "Domain list filename incorrect or not provided")
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


