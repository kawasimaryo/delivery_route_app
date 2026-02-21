# frozen_string_literal: true

FactoryBot.define do
  factory :delivery_point do
    association :delivery_route
    sequence(:name) { |n| "配達先#{n}" }
    address { "東京都渋谷区1-1-1" }
    position { 0 }
    status { :pending }
  end
end
