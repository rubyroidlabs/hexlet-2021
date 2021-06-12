# frozen_string_literal: true

class User < ActiveRecord::Base
  enum status: %i[registered active pending stop]
  has_many :learned_definitions, dependent: :destroy
  has_many :definitions, through: :learned_definitions

  scope :by_id, ->(telegram_id) { where('telegram_id = ?', telegram_id) }
end
