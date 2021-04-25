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
      data_format, content = read_file_data(@path_to_csv)
      raw_urls = Parser.parse(content, data_format)

      url_list = UrlList.new(raw_urls)
      urls = url_list.filter(@options).normalize.urls

      head_only = @options[:filter].empty?
      pool_size = @options[:parallel]
      futures = RequestWorker.send_requests(urls, head_only, pool_size)
      futures.each(&handle_future)

      @result_data
    end

    private

    def read_file_data(file_path)
      [
        File.extname(file_path)[1..],
        File.read(file_path)
      ]
    end

    def handle_future
      proc do |future|
        data = future.value

        unless @options[:filter].empty?
          next unless data[:error].nil?
          next unless data[:body].match?(/#{@options[:filter]}/i)
        end

        aggregate_result(data)
        log(data)
      end
    end

    def aggregate_result(data)
      @result_data[:total] += 1
      if data[:error].nil?
        @result_data[:success] += 1 if data[:status].between?(200, 399)
        @result_data[:failed] += 1 if data[:status].between?(400, 599)
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
