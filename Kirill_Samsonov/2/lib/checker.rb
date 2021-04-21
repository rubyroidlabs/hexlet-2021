require 'net/http'
require 'pry'
require_relative './reader'
require_relative './output'

class Checker
  def initialize(source, options)
    @source = source
    @options = options
  end

  def run
    reader = Reader.new(@source, @options)
    domains = reader.read
    domains = filter_domains(domains)

    summary = check_domains(domains) do |domain_check_result|
      Output.print_line format_domain_result(domain_check_result)
    end

    Output.print_line format_summary(summary)
  end

  def check_domains(domains)
    result = { total: 0, success: 0, failed: 0, errored: 0 }

    domains.each do |domain|
      begin
        # Didn't find out how to make destructuring in es6 style. This looks ugly
        response, elapsed_time = check_domain(domain).values_at(:response, :elapsed_time)

        next if skip_domain?(response)

        code = response.code.to_i
        if success_status?(code)
          result[:success] += 1
        else
          result[:failed] += 1
        end
        yield ({ domain: domain, status: response.code, latency: elapsed_time })
      rescue StandardError => e
        result[:errored] += 1
        yield ({ domain: domain, error: true, message: e.message })
      end
    end

    result[:total] = result[:success] + result[:failed] + result[:errored]
    result
  end

  def check_domain(name)
    start_time = Time.now
    response = Net::HTTP.get_response(name, '/')
    elapsed_time = ((Time.now - start_time) * 1000).round
    { response: response, elapsed_time: elapsed_time }
  end

  private

  def skip_domain?(response)
    filtered_by_name = @options[:filter] && !response.body.include?(@options[:filter])
    filtered_open_source = @options[:exclude_solutions] && response.body.include?('open source')
    filtered_by_name || filtered_open_source
  end

  def filter_domains(domains)
    return domains unless @options[:no_subdomains]

    domains.reject { |domain| subdomain?(domain) }
  end

  def subdomain?(domain)
    domain.count('.') > 1
  end

  def success_status?(code)
    code >= 200 && code < 400
  end

  def format_domain_result(line)
    return "#{line[:domain]} - ERROR: #{line[:message]}" if line[:error]

    "#{line[:domain]} - #{line[:status]} (#{line[:latency]}ms)"
  end

  def format_summary(summary)
    "\nTotal: #{summary[:total]}, Success: #{summary[:success]}, Failed: #{summary[:failed]}, Errored: #{summary[:errored]}"
  end
end