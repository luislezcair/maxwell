# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    sequence(:name) { |n| "Argentina #{n}" }
  end
end
