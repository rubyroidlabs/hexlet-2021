# frozen_string_literal: true

require 'aasm'
# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Rails/ApplicationRecord

class User < ActiveRecord::Base
  include AASM
  include Logging

  SCHEDULE_TYPES = [
    [15],
    [10, 21],
    [9, 15, 21],
    [8, 13, 18, 23],
    [8, 12, 16, 20, 24],
    [8, 11, 14, 17, 20, 23]
  ].freeze

  has_many :learned_words, dependent: :destroy
  has_many :definitions, through: :learned_words

  validates :telegram_id, presence: true, uniqueness: true, case_sensitive: false
  validates :words_count, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 6 }, allow_nil: true

  aasm column: 'status' do
    state :new, initial: true
    state :registered
    state :scheduled
    state :waiting

    event :register do
      transitions from: :new, to: :registered
    end

    event :init_schedule do
      transitions from: :registered, to: :scheduled
    end

    event :get_word do
      transitions from: :scheduled, to: :waiting
    end

    event :learn_word do
      transitions from: :waiting, to: :scheduled
    end
  end

  def add_schedule(count)
    update(
      status: 'scheduled',
      words_count: count.to_i
    )
  end

  def receive_definition!(definition)
    transaction do
      get_word! if scheduled?
      definitions << definition
    end
  end

  def upcoming_time_equal?(time)
    SCHEDULE_TYPES[words_count - 1].any?(time)
  end

  def miss_time?(time)
    waiting? && upcoming_time_equal?(time - 2)
  end
end

# rubocop:enable Rails/ApplicationRecord
# rubocop:enable Lint/RedundantCopDisableDirective
