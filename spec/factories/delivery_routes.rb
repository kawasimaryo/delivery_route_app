# frozen_string_literal: true

FactoryBot.define do
  factory :delivery_route do
    association :user
    sequence(:name) { |n| "配達ルート#{n}" }
    status { :draft }
    date { Date.current }
  end
end
