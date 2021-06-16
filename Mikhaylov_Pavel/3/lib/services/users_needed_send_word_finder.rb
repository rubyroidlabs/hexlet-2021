# frozen_string_literal: true

require_relative '../../models/user'
require_relative '../../models/learned_word'

class UsersNeededSendWordFinder
  def initialize(users)
    @users = users
  end

  def call
    @users.filter do |user|
      LearnedWord.where(created_at: Time.current.all_day, user_id: user.id).count < user.words_per_day
    end
  end
end
