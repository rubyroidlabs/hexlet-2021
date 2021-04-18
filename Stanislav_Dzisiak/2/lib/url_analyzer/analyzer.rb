# frozen_string_literal: true

module UrlAnalyzer
  class Analyzer
    def initialize(path_to_csv, options)
      @path_to_csv = path_to_csv
      @options = options
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

      futures = urls.map do |url|
        request_pool.future.send_request url
      end

      futures.each(&handle_future)
    end

    def handle_future
      proc do |future|
        data = future.value

        unless data[:error].nil?
          if @options[:filter].empty?
            @result_data[:total] += 1
            @result_data[:errored] += 1
          end
          next
        end

        next unless data[:body].match?(/#{@options[:filter]}/i)

        @result_data[:total] += 1
        @result_data[:success] += 1 if data[:status].between? 200, 399
        @result_data[:failed] += 1 if data[:status].between? 400, 599

        log data
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
