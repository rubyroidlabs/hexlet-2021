# frozen_string_literal: true

require_relative '../models/word'
require_relative '../models/user'
require_relative '../models/learned_word'
require_relative '../config/connection'
require_relative 'postman/send_reminder'
require_relative 'postman/send_word'

class Teacher
  def self.send_word
    User
      .learning
      .reject(&:done_for_today?)
      .each do |user|
        word = user.new_word
        Postman::SendWord.send(word, user)
        user.wait!
      end
  end

  def self.remind
    User
      .waiting
      .filter(&:need_to_send_reminder?)
      .each do |user|
        Postman::SendReminder.send(user)
      end
  end
end
