# frozen_string_literal: true

class Response
  attr_reader :code

  def initialize(data, options)
    @data = data
    @options = options
    @code = @data.code.to_i
  end

  def skip?
    filtered_by_name = @options[:filter] && !@data.body.include?(@options[:filter])
    filtered_open_source = @options[:exclude_solutions] && @data.body.include?('open source')
    !!(filtered_by_name || filtered_open_source)
  end

  def success?
    @code >= 200 && @code < 400
  end
end
