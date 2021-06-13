# frozen_string_literal: true

class Word < ActiveRecord::Base
  has_many :user_words, dependent: :destroy
  has_many :users, through: :user_words

  def to_s
    "#{value} - #{meaning}"
  end
end
