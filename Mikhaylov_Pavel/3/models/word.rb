# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord

require 'active_record'

class Word < ActiveRecord::Base
  has_many :users, through: :learned_words
  has_many :learned_words, dependent: :destroy

  def to_s
    "#{value} - #{definition}"
  end
end

# rubocop:enable Rails/ApplicationRecord
