# frozen_string_literal: true

require_relative '../models/word'
require 'json'
require 'ruby-progressbar'
require 'active_record'
require_relative '../connection'


dictionary = JSON.parse(File.read('dictionary.json'))
progressbar = ProgressBar.create(title: 'Loaded words', starting_at: 0, total: dictionary.size)

dictionary.each do |word|
  Word.create(value: word[0], definition: word[1])
  progressbar.increment
end
