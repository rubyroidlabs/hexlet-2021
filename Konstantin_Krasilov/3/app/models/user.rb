# frozen_string_literal: true
require 'aasm'

class User < ActiveRecord::Base
  include AASM

  has_many :user_words, dependent: :destroy
  has_many :words, through: :user_words

  aasm do
    state :waiting_max_word, initial: true
    state :sleeping, :waiting_smiley, :learning

    event :answer_max_word do
      transitions from: :sleeping, to: :waiting_max_word
    end

    event :answer_smiley do
      transitions from: :learning, to: :waiting_smiley
    end

    event :learn do
      transitions from: [:waiting_max_word, :waiting_smiley, :sleeping], to: :learning
    end

    event :sleep do
      transitions from: :waiting_smiley, to: :sleeping
    end
  end
end
