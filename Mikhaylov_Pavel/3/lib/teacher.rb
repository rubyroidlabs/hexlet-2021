# frozen_string_literal: true

require_relative '../models/word'
require_relative '../models/user'
require_relative '../models/learned_word'
require_relative '../config/connection'
require_relative 'actions'
require 'pry'

class Teacher
  def self.send_word
    User
      .learning
      .reject(&:finished?)
      .each do |user|
        word = user.new_word
        Actions::SendWord.send(word, user)
        user.wait!
      end
  end

  def self.remind
    User
      .waiting
      .filter(&:need_to_send_reminder?)
      .each do |user|
        Actions::SendReminder.send(user)
      end
  end
end
