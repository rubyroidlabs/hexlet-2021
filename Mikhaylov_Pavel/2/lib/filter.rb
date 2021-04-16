# frozen_string_literal: true

class Filter
  def initialize(data, options)
    @data = data
    @options = options
  end

  def filtered_data
    result = []
    result << if @options.key?(:subdomains)
                filter_subdomens
              elsif @options.key?(:solutions)
                filter_by_opensource
              else
                @data
              end
    result.flatten
  end

  def filter_subdomens
    @data.reject { |url| url.count('.') > 1 }
  end

  def filter_by_opensource; end
end
