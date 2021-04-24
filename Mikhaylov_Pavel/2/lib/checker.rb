# frozen_string_literal: true

require 'csv'
require_relative 'checker/csv_reader'
require_relative 'checker/filter'
require_relative 'checker/http_service'
require_relative 'checker/printer'

class Checker
  def initialize(csv_path, options)
    @csv_path = csv_path
    @options = options
  end

  def run
    print_out
  end

  def csv
    CsvReader.new(@csv_path)
  end

  def filtered_data
    Filter.new(csv.data, @options).apply_filter
  end

  def responses
    HttpService.new(filtered_data, search_word, parallel).fetch_all
  end

  def print_out
    Printer.new(responses).print
  end

  def search_word
    @options.fetch(:filterword, '')
  end

  def parallel
    @options.fetch(:parallel, 1)
  end
end
