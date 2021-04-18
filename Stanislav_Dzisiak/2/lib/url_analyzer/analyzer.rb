# frozen_string_literal: true

require 'faraday'
require 'benchmark'
require 'csv'

module UrlAnalyzer
  class Analyzer
    def initialize(path_to_csv, options = {})
      @path_to_csv = path_to_csv
      @options = options.to_h
    end

    def analyze
      data_format = File.extname(@path_to_csv)[1..]
      content = File.read @path_to_csv
      urls = Utils::Parser.parse content, data_format
      url_list = Utils::UrlList.new urls
      filtered_urls = url_list.filter(@options).normalize.urls

      # filtered_urls.each do |url|
      #   begin
      #     Faraday.get "http://#{url}"
      #     puts url
      #   rescue Exception => e
      #     puts e
      #   end
      # end
      puts filtered_urls
      # response = Faraday.get 'http://jopajopa.com'
      # puts response.status
      # result = Benchmark.measure do
      #   100000.times { response.body.match? '2017' }
      # end
      # puts result
      'result'
    end
  end
end
