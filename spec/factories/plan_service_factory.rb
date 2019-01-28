# frozen_string_literal: true

FactoryBot.define do
  factory :plan_service do
    sequence(:name) { |n| "Simétrico #{n + 100} Gbps" }
  end
end
