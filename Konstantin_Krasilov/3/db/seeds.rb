# frozen_string_literal: true

require_relative '../app/models/word'
require 'progress_bar'
require 'json'

words = JSON.parse(File.read(File.join(__dir__, 'words.json')))
bar = ProgressBar.new(words.count, :bar, :percentage, :elapsed)

words.each do |word|
  Word.create(value: word[0], meaning: word[1])
  bar.increment!
end
