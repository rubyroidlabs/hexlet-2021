# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    telegram_id { Faker::Number.number(digits: 9) }
  end
end
