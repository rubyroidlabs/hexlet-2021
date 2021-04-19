# frozen_string_literal: true

require 'csv'

module FileLoader
  def load_file(file_path)
    raise 'Unknown file' unless File.exist?(file_path)
    raise 'Not a csv' unless file_path.include?('.csv')

    load(file_path)
  end

  private

  def load(file_path)
    values = []

    CSV.foreach(file_path) do |row|
      values << row
    end

    values.flatten!
  end
end
