# frozen_string_literal: true

require_relative '../../models/user'
require_relative '../../models/learned_word'

class UsersNeededReminderFinder
  REMINDER_IN_MINUTES = 90

  def initialize(users)
    @users = users
  end

  def call
    @users.filter do |user|
      last_word_at = LearnedWord.where(user_id: user.id).last.created_at
      (Time.current - last_word_at) / 60 > REMINDER_IN_MINUTES
    end
  end
end
