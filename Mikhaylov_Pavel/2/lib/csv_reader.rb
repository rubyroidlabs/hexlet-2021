# frozen_string_literal: true

class CsvReader
  attr_reader :data

  def initialize(path)
    @data = CSV.read(path).flatten
  end
end
