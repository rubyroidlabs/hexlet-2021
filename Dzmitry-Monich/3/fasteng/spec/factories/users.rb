# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    telegram_id { Faker::Internet.uuid }
  end
end
