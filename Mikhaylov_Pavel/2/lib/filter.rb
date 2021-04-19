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
      case key
      when :subdomains
        subdomains << filter_subdomains
      when :solutions
        os << filter_opensource
      else
        result << @data
      end
    end
    result = conclusion_subdomains_and_os(subdomains, os)
  end

  def conclusion_subdomains_and_os(subdomains, os)
    if subdomains.empty?
      os.flatten
    elsif os.empty?
      subdomains.flatten
    else
      subdomains.flatten & os.flatten
    end
  end

  def filter_subdomains
    @data.reject { |url| url.count('.') > 1 }
  end

  def filter_opensource
    opensources = CSV.read('os.csv').flatten
    @data.reject do |row|
      opensources.find { |res| row.include?(res) }
    end
  end
end
