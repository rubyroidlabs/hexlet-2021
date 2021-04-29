# frozen_string_literal: true

class Definition < ActiveRecord::Base
  validates :word, presence: true, uniqueness: true
  validates :description, presence: true

  has_many :learned_words, dependent: :destroy
  has_many :users, through: :learned_words

  def to_s
    "#{word}: #{description}"
  end
end
