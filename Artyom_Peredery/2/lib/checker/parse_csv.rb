# frozen_string_literal: true

require 'csv'

module ParseCSV
  def parse_csv(file_path)
    raise 'Specify file' if file_path.nil?
    raise 'Unsupported file format. Should be CSV' unless file_path.include?('.csv')

    absolute_path = File.expand_path(file_path, File.dirname(__FILE__))
    @data = CSV.read(absolute_path)
    @data.flatten!
  end
end
