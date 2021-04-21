# frozen_string_literal: true

class Reader
  def initialize(source, options)
    @file_name = source
    @options = options
  end

  def read
    file = File.open(@file_name)
    file.readlines.map(&:chomp)
  rescue StandardError => e
    puts e.message
    exit(1)
  ensure
    file.close unless file&.nil?
  end
end
