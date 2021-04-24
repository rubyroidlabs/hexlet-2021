# frozen_string_literal: true

require 'active_record'

class User < ActiveRecord::Base
  validates :telegram_id, presence: true, uniqueness: true
end
