# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord

require 'aasm'
require 'active_record'

class User < ActiveRecord::Base
  include AASM

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
end

# rubocop:enable Rails/ApplicationRecord
