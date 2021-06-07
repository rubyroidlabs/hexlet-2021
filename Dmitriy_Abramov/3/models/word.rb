# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord

require 'active_record'

class Word < ActiveRecord::Base
  has_many :learned_words, dependent: :destroy
  has_many :users, through: :learned_words

  validates :value, presence: true, uniqueness: true
  validates :description, presence: true

  def to_s
    "#{value} - #{description}"
  end
end

# rubocop:enable Rails/ApplicationRecord
