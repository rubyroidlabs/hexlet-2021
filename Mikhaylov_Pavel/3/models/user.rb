# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord

require 'aasm'
require 'active_record'
require_relative 'learned_word'

class User < ActiveRecord::Base
  include AASM

  REMINDER_IN_MINUTES = 90

  has_many :words, through: :learned_words
  has_many :learned_words, dependent: :destroy

  enum state: %i[unregistred learning waiting stopped]

  aasm column: :state, enum: true do
    state :unregistred, initial: true
    state :learning, :waiting, :stopped

    event :learn do
      transitions from: %i[unregistred stopped waiting], to: :learning
    end

    event :wait do
      transitions from: :learning, to: :waiting
    end

    event :stop do
      transitions from: %i[unregistred learning waiting], to: :stopped
    end
  end

  def done_for_today?
    LearnedWord.where(created_at: Time.current.all_day, user_id: id).count >= words_per_day
  end

  def need_to_send_reminder?
    last_word_at = LearnedWord.where(user_id: id).last.created_at
    (Time.current - last_word_at) / 60 > REMINDER_IN_MINUTES
  end
end

# rubocop:enable Rails/ApplicationRecord
