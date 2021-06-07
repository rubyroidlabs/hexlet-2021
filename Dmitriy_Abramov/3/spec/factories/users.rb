# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Games::HalfLife.character }
    uid { Faker::Number.unique.number(digits: 9) }

    factory :user_session_started do
      daily_words_count { 3 }
      after(:build, &:register!)

      factory :user_waiting do
        after(:build, &:wait_for_answer!)

        factory :user_session_stopped do
          after(:build, &:stop_session!)
        end
      end
    end
  end
end
