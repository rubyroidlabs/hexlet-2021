# frozen_string_literal: true

FactoryBot.define do
  factory :definition do
    word { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end
