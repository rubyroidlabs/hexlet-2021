# frozen_string_literal: true

class Filter
  def initialize(data, options)
    @data = data
    @options = options
  end

  def filtered_data
    if @options.empty?
      @data
    else
      filter_by_options
    end
  end

  def filter_by_options
    result = []
    subdomains = []
    os = []
    @options.each_key do |key|
      urls = result.empty? ? @data : result.flatten
      case key
      when :subdomains
        subdomains << filter_subdomens(urls)
      when :solutions
        os << filter_by_opensource(urls)
      else
        result << @data
      end
    end
    result = if subdomains.empty?
               os.flatten
             elsif os.empty?
               subdomains.flatten
             else
               subdomains.flatten & os.flatten
             end
  end

  def filter_subdomens(urls)
    urls.reject { |url| url.count('.') > 1 }
  end

  def filter_by_opensource(urls)
    opensources = CSV.read('os.csv').flatten
    urls.reject do |row|
      opensources.find { |res| row.include?(res) }
    end
  end
end
