# frozen_string_literal: true

FactoryBot.define do
  factory :key_result, class: KeyResult do
    title { Faker::Lorem.sentence }
    goal

    trait :completed do
      completed_at { DateTime.now + 1.month }
    end

    trait :in_progress do
      started_at { DateTime.now }
      completed_at { nil }
    end
  end
end
