# frozen_string_literal: true

require 'csv'

class CsvReader
  def initialize(path)
    @path = path
  end

  def data
    raise StandardError, 'File is empty' if CSV.read(@path).empty?

    CSV.read(@path).flatten
  end
end
