# frozen_string_literal: true

require 'csv'

class CsvReader
  def initialize(path)
    @path = path
  end

  def data
    CSV.read(@path).flatten
  end
end
