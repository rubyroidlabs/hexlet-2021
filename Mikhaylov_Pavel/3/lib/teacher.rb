# frozen_string_literal: true

require_relative '../models/word'
require_relative '../models/user'
require_relative '../config/connection'
require_relative 'postman/send_reminder'
require_relative 'postman/send_word'
require_relative 'services/new_word_for_user'
require_relative 'services/users_needed_reminder_finder'
require_relative 'services/users_needed_send_word_finder'

class Teacher
  def self.send_word
    users_for_send = UsersNeededSendWordFinder.new(User.learning).call
    users_for_send.each do |user|
      word = NewWordForUser.new(user).call
      Postman::SendWord.send(word, user)
      user.wait!
    end
  end

  def self.remind
    users_for_remind = UsersNeededReminderFinder.new(User.waiting).call
    users_for_remind.each do |user|
      Postman::SendReminder.send(user)
    end
  end
end
