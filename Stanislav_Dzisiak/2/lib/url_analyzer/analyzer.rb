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
      urls = Parser.parse content, data_format
      filtered_urls = Utils.urls_filter urls, @options
      puts filtered_urls
      # urls = CSV.read(file)
      # http://abelitsia.gr/
      # puts @path_to_csv
      # puts Dir.pwd
      # puts File.expand_path('bin/console')
      # file = File.open('/etc/hosts')
      # file_data = file.readlines.size
      # check incorrect urls
      # puts file_data
      # response = Faraday.get 'http://abelitsia.gr/'
      # response = Faraday.get 'http://jopajopa.com'
      # puts response.status
      # result = Benchmark.measure do
      #   100000.times { response.body.match? '2017' }
      # end
      # puts result
      # puts urls
      'result'
    end
  end
end
