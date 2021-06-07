# frozen_string_literal: true

require 'open-uri'
require_relative '../models/word'
require_relative './connection'

URI.open('https://raw.githubusercontent.com/sujithps/Dictionary/master/Oxford%20English%20Dictionary.txt') do |f|
  f.each_line do |line|
    word_line = line.split("\n").first
    next if word_line.nil?

    word, description = word_line.split('  ')

    Word.create(value: word, description: description) if !word.nil? && !description.nil?
  end
end
