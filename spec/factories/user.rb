# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    username { Faker::Internet.user_name }
    password_digest { "letmein1" }
  end
end
