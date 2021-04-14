# frozen_string_literal: true

class CsvReader
  # attr_writer :csv_data
  attr_accessor :data

  def initialize(path)
    @data = CSV.read(path).flatten
  end
end
