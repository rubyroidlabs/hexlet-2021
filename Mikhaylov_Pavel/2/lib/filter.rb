# frozen_string_literal: true

class Filter
  attr_accessor :data, :options

  def initialize(data, options)
    @data = data
    @options = options
  end

  def filtered_data
    result = []
    if @options.key?(:subdomains)
      result << filter_subdomens
    elsif @options.key?(:solutions)

    else
      result << @data
    end
    result.flatten
  end

  def filter_subdomens
    @data.reject { |url| url.count('.') > 1 }
  end

  def filter_by_word; end

  def filter_by_opensource; end
end
