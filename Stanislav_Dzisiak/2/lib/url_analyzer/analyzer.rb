# frozen_string_literal: true

module UrlAnalyzer
  class Analyzer
    def initialize(path_to_csv, options)
      @path_to_csv = path_to_csv
      @options = options
    end

    def analyze
      data_format = File.extname(@path_to_csv)[1..]
      content = File.read @path_to_csv
      raw_urls = Utils::Parser.parse content, data_format

      url_list = Utils::UrlList.new raw_urls
      urls = url_list.filter(@options).normalize.urls

      send_requests urls

      'result'
    end

    private

    def send_requests(urls)
      request_pool = RequestWorker.pool size: @options[:parallel]

      furures = urls.map do |url|
        request_pool.future.send_request url
      end

      furures.each do |future|
        puts future.value
      end
    end
  end
end
