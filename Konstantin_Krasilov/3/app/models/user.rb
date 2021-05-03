# frozen_string_literal: true

class User < ActiveRecord::Base
  enum conversation_status: {
    send_max_word: 0,
    send_smiley: 1,
    conversation_break: 2
  }

  has_many :user_words, dependent: :destroy
  has_many :words, through: :user_words
end
