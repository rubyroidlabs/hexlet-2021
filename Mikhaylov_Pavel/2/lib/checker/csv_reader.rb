# frozen_string_literal: true

require 'csv'

class CsvReader
  attr_reader :data

  def initialize(path)
    @data = CSV.read(path).flatten
  end
end
