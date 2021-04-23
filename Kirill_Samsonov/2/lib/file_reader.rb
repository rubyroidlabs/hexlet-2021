# frozen_string_literal: true

class FileReader
  def initialize(source, options)
    @file_name = source
    @options = options
  end

  def read
    file = File.open(@file_name)
    file.readlines.map(&:chomp)
  ensure
    file&.close
  end
end
