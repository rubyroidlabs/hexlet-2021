# frozen_string_literal: true

class Filter
  def initialize(data, options)
    @data = data
    @options = options
  end

  def apply_filter
    if @options.key?(:subdomains) || @options.key?(:solutions)
      filter_by_options
    else
      @data
    end
  end

  private

  def filter_by_options
    subdomains = []
    open_source = []

    @options.each_key do |key|
      case key
      when :subdomains
        subdomains << filter_subdomains
      when :solutions
        open_source << filter_opensource
      end
    end

    conclusion_subdomains_and_os(subdomains, open_source)
  end

  def conclusion_subdomains_and_os(subdomains, open_source)
    if subdomains.empty?
      open_source.flatten
    elsif open_source.empty?
      subdomains.flatten
    else
      subdomains.flatten & open_source.flatten
    end
  end

  def filter_subdomains
    @data.reject { |url| url.count('.') > 1 }
  end

  def filter_opensource
    opensources = CsvReader.new('os.csv').data
    @data.reject do |row|
      opensources.find { |res| row.include?(res) }
    end
  end
end
