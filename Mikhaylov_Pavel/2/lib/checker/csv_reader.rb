# frozen_string_literal: true

require 'csv'

class CsvReader
  def initialize(path)
    @path = path
  end

  def data
    data = CSV.read(@path)
    raise StandardError, 'File is empty' if data.empty?

    data.flatten
  end
end
