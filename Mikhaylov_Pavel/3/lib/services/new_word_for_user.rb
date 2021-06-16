# frozen_string_literal: true

require_relative '../../models/user'
require_relative '../../models/word'
require_relative '../../models/learned_word'

class NewWordForUser
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    word = Word.where.not(id: user.learned_words).sample
    LearnedWord.create(user_id: user.id, word_id: word.id)
    word
  end
end
