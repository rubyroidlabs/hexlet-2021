# frozen_string_literal: true

module Fasteng
  module DictionaryManager
    module DictionaryCreator
      class << self
        def call
          return if Definition.any?

          Definition.create(definitions)
        end

        private

        def definitions
          filepath = Fasteng.root_path.join('data/dictionary.txt')
          separator = '  '

          prepared =
            File
            .readlines(filepath, chomp: true)
            .map(&:strip)
            .reject { |line| line.empty? || line.split(separator).first =~ /^[A-Z]$/ }
            .each_with_object({}) do |line, acc|
              word, *rest = line.split(separator)
              acc[word] = rest.join(separator)
            end

          prepared.map { |word, descr| { word: word, description: descr } }
        end
      end
    end
  end
end
