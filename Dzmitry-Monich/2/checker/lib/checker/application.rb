module Checker
  class Application
    def initialize(options = {})
      @options = options
    end

    def call(filepath)
      absolute_path = Checker.root_path.join(filepath)
      validate(absolute_path)

      urls = parse_content(absolute_path)
      filter_urls(urls)
    end

    private

    attr_reader :options

    def filter_urls(urls)
      keys = options.select { |_k, v| v == true }.keys
      Filter.filter(urls, keys)
    end

    def parse_content(filepath)
      Parser.parse(filepath)
    end

    def validate(filepath)
      raise ArgumentError, 'no such a file' unless File.exist?(filepath)
    end
  end
end
