# frozen_string_literal: true

FactoryBot.define do
  factory :province do
    sequence(:name) { |n| "Corrientes #{n}" }
    country
  end
end
