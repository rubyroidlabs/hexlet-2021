# frozen_string_literal: true

FactoryBot.define do
  factory :word do
    value { Faker::Lorem.unique.word }
    description { Faker::Games::Pokemon.location }
  end
end
