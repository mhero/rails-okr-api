# frozen_string_literal: true

FactoryBot.define do
  factory :goal, class: Goal do
    association :owner, factory: :user

    title { Faker::Lorem.sentence }
    start_date { DateTime.now }
    end_date { DateTime.now + 1.month }
  end
end
