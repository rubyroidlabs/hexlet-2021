# frozen_string_literal: true

# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Rails/ApplicationRecord

class Definition < ActiveRecord::Base
  validates :word, presence: true, uniqueness: true
  validates :description, presence: true

  has_many :learned_words, dependent: :destroy
  has_many :users, through: :learned_words
end

# rubocop:enable Rails/ApplicationRecord
# rubocop:enable Lint/RedundantCopDisableDirective
