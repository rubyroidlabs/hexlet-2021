# frozen_string_literal: true

require 'aasm'
require 'active_record'
require 'pry'
require 'date'
require_relative 'learned_word'
require_relative 'word'

class User < ActiveRecord::Base
  include AASM

  REMINDER_IN_MINUTES = 90

  has_many :words, through: :learned_words
  has_many :learned_words, dependent: :destroy

  aasm do
    state :new, initial: true
    state :learning, :waiting, :stopped

    event :learn do
      transitions from: %i[new stopped waiting], to: :learning
    end

    event :wait do
      transitions from: :learning, to: :waiting
    end

    event :stop do
      transitions from: %i[new learning waiting], to: :stopped
    end
  end

  def new_word
    word = Word.where.not(id: learned_words).sample
    LearnedWord.create(user_id: id, word_id: word.id)
    word
  end

  def finished?
    LearnedWord.where(created_at: Time.current.all_day, user_id: id).count >= words_per_day
  end

  def need_to_send_reminder?
    last_word_at = LearnedWord.where(user_id: id).last.created_at
    (Time.current - last_word_at) / 60 > REMINDER_IN_MINUTES
  end
end
