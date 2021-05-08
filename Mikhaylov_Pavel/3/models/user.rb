# frozen_string_literal: true

require 'aasm'
require 'active_record'

class User < ActiveRecord::Base
  include AASM

  aasm do
    state :new, initial: true
    state :learning, :stopped

    event :learn do
      transitions from: %i[new learning stopped], to: :learning
    end

    event :stopped do
      transitions from: %i[new learning], to: :stopped
    end
  end

  has_many :words, through: :learned_words
  has_many :learned_words, dependent: :destroy
end
