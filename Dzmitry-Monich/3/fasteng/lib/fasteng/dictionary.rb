# frozen_string_literal: true

module Fasteng
  module Dictionary
    module_function

    def setup
      return if Definition.any?

      Definition.create(definitions)
    end

    def definitions
      filepath = Fasteng.root_path.join('data/dictionary.txt')
      separator = '  '

      prepared =
        File
        .readlines(filepath, chomp: true)
        .map(&:strip)
        .reject { |line| line == '' || line.split(separator).first =~ /^[A-Z]$/ }
        .each_with_object({}) do |line, acc|
          word, *rest = line.split(separator)
          acc[word] = rest.join(separator)
        end

      prepared.map { |word, descr| { word: word, description: descr } }
    end
  end
end
