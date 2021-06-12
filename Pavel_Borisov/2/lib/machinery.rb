# frozen_string_literal: true

require 'optparse'
require 'csv'
require 'net/http'
require 'nokogiri'

# Uses OptionParser to collect options into a hash
class CliParser
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

# Runs check for a single domain and contains the result
class DomainChecker
  attr_reader :domain, :code, :response_time, :body, :status

  def initialize(domain)
    @domain = domain
    @status = :unchecked
  end

  def check!
    begin
      timed_http_request
    rescue StandardError => e
      @status = :errored
      cause = ('Timeout' if e.is_a? Timeout::Error) || e.cause
      @error_message = "ERROR (#{cause})"
    end
    self
  end

  def result
    case @status
    when :got_response
      "#{@domain} - #{@code} (#{@response_time})"
    when :errored
      "#{@domain} - #{@error_message}"
    when :unchecked
      "#{@domain} - hasn't been checked"
    end
  end

  private

  def timed_http_request
    http = Net::HTTP.new(@domain)
    http.open_timeout = 1
    http.read_timeout = 1
    start_time = Time.now.utc
    response = http.get('/')
    end_time = Time.now.utc
    @response_time = "#{((end_time - start_time) * 1000).round}ms"
    @code = response.code.to_i
    @body = response.body
    @status = :got_response
  end
end

# Reads domains list from a file, filters the list according to the supplied options.
# Checks the domains using DomainChecker, filters the results if --filter option is specified.
# Provides methods to format results and stats for output.
class DomainsList
  attr_reader :list

  def initialize(filename, options)
    @initial_list = CSV.read(filename).map(&:first)

    reject_subdomains! if options[:'no-subdomains']
    reject_solutions! if options[:'exclude-solutions']

    @filtered_word = options[:filter]
    @list = @initial_list.map { |domain| DomainChecker.new(domain) }
  end

  def process!
    total_count = @list.count
    processed_count = 0
    @list.each do |item|
      item.check!
      processed_count += 1
      completion_percentage = (processed_count / total_count.to_f * 100).to_i
      yield(completion_percentage, item.domain) if block_given?
    end
    keep_results_with_word!(@filtered_word) if @filtered_word
    self
  end

  def results
    @list.map(&:result)
  end

  def stats
    total = @list.count
    errored = @list.count { |item| item.status == :errored }

    success = @list.count do |item|
      item.status == :got_response && (200..399).cover?(item.code)
    end

    failed = @list.count do |item|
      item.status == :got_response && (400..599).cover?(item.code)
    end

    "Total: #{total}, Success: #{success}, Failed: #{failed}, Errored: #{errored}"
  end

  private

  def reject_subdomains!
    @initial_list.filter! { |domain| domain.count('.') == 1 }
  end

  def reject_solutions!
    @initial_list.filter! do |domain|
      !domain.match(/(\bgitlab\b|\bredmine\b|\bgit\b|\brepo\b|\brm\b|\bsource\b|\bsvn\b)/)
    end
  end

  def keep_results_with_word!(word)
    @list.keep_if do |response|
      body_text = Nokogiri::HTML.parse(response.body).css('body').text
      body_text.downcase.match? word.downcase
    end
  end
end
