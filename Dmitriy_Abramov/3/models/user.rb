# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord

require 'active_record'
require 'aasm'
require_relative './learned_word'

class User < ActiveRecord::Base
  include AASM

  has_many :learned_words, dependent: :destroy
  has_many :words, through: :learned_words

  validates :uid, presence: true, uniqueness: true, numericality: true
  validates :daily_words_count, numericality: { greater_than: 0, less_than_or_equal_to: 6 }, allow_nil: true

  aasm do
    state :unregistred, initial: true
    state :session_started, :session_stopped, :waiting_for_answer

    event :register do
      transitions from: :unregistred, to: :session_started
    end

    event :start_session do
      transitions from: :session_stopped, to: :session_started
    end

    event :wait_for_answer do
      transitions from: :session_started, to: :waiting_for_answer
    end

    event :recieve_answer do
      transitions from: :waiting_for_answer, to: :session_started
    end

    event :stop_session do
      transitions from: %i[session_started waiting_for_answer], to: :session_stopped
    end
  end

  def learn
    possible_words = Word.where.not(id: learned_words)
    offset = rand(possible_words.count)

    word = possible_words.offset(offset).first
    LearnedWord.create(user_id: id, word_id: word.id) if word
    word
  end

  def done_for_today?
    learned_today = LearnedWord.where(created_at: Time.current.all_day, user_id: id)
    learned_today.size >= daily_words_count
  end
end

# rubocop:enable Rails/ApplicationRecord
