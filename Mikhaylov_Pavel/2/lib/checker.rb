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
    csv_data
    responses
    print_out
  end

  def csv_data
    CsvReader.new(@csv_path)
  end

  def filter_data
    Filter.new(csv_data.data, @options).filtered_data
  end

  def responses
    HttpService.new(filter_data, search_word).fetch_all
  end

  def print_out
    Printer.new(responses).print
  end

  def search_word
    @options.fetch(:filterword, '')
  end
end
