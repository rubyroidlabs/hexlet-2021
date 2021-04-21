# frozen_string_literal: true

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
    end

    def analyze
      data_format = File.extname(@path_to_csv)[1..]
      content = File.read @path_to_csv
      raw_urls = Utils::Parser.parse content, data_format

      url_list = Utils::UrlList.new raw_urls
      urls = url_list.filter(@options).normalize.urls

      send_requests urls

      @result_data
    end

    private

    def send_requests(urls)
      request_pool = RequestWorker.pool size: @options[:parallel]
      head_only = @options[:filter].empty?

      futures = urls.map do |url|
        request_pool.future.send_request url, head_only
      end

      futures.each(&handle_future)
    end

    def handle_future
      proc do |future|
        data = future.value

        unless @options[:filter].empty?
          next unless data[:error].nil?
          next unless data[:body].match?(/#{@options[:filter]}/i)
        end

        aggregate_result data
        log data
      end
    end

    def aggregate_result(data)
      @result_data[:total] += 1
      if data[:error].nil?
        @result_data[:success] += 1 if data[:status].between? 200, 399
        @result_data[:failed] += 1 if data[:status].between? 400, 599
      else
        @result_data[:errored] += 1
      end
    end

    def log(data)
      detail =
        if data[:error].nil?
          "#{data[:status]} (#{data[:time]}ms)"
        else
          "ERROR: #{data[:error]}"
        end

      puts "#{data[:url]} - #{detail}"
    end
  end
end
