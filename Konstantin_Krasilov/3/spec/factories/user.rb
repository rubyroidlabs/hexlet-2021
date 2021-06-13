# frozen_string_literal: true

require 'factory_bot'
require_relative '../support/factory_bot'
require_relative '../../config/connection'
require 'active_record'

FactoryBot.define do
  factory :user do
    telegram_id { rand(999) }
  end
end
