# frozen_string_literal: true

FactoryBot.define do
  factory :goal, class: Goal do
    association :owner, factory: :user

    title { Faker::Lorem.sentence }
    started_at { DateTime.now }
    ended_at { DateTime.now + 1.month }
  end
end
