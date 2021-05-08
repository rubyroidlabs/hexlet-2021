# frozen_string_literal: true

require 'logger'

module UrlAnalyzer
  class Analyzer
    def initialize(path_to_csv, options = {})
      @path_to_csv = path_to_csv
      @options = {
        parallel: 1,
        filter: '',
        no_subdomains: false,
        exclude_solutions: false,
        **options
      }
      @result_data = { total: 0, success: 0, failed: 0, errored: 0 }
      @logger = Logger.new($stdout, formatter: proc { |*, msg| "#{msg}\n" })
    end

    def analyze
      data_format = File.extname(@path_to_csv)[1..]
      content = File.read(@path_to_csv)
      raw_urls = Parser.parse(content, data_format)

      urls = UrlList.filter(raw_urls, @options)

      head_only = @options[:filter].empty?
      pool_size = @options[:parallel]
      responses = RequestWorker.send_requests(urls, head_only, pool_size)
      responses.each(&handle_response)

      @result_data
    end

    private

    def handle_response
      proc do |response|
        data = response.value

        unless @options[:filter].empty?
          next unless data[:error].nil?
          next unless data[:body].match?(/#{@options[:filter]}/i)
        end

        aggregate_result(data)
      end
    end

    def aggregate_result(data)
      @result_data[:total] += 1
      if data[:error].nil?
        @result_data[:success] += 1 if data[:status].between?(200, 399)
        @result_data[:failed] += 1 if data[:status].between?(400, 599)
        @logger.info("#{data[:url]} - #{data[:status]} (#{data[:time]}ms)")
      else
        @result_data[:errored] += 1
        @logger.info("#{data[:url]} - ERROR: #{data[:error]}")
      end
    end
  end
end
