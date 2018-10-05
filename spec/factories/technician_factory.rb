# frozen_string_literal: true

FactoryBot.define do
  factory :technician do
    firstname { 'Técnico X' }
    lastname { 'Y Z' }

    factory :technician_with_sequence do
      sequence(:firstname) { |n| "Técnico X#{n}" }
      sequence(:lastname) { |n| "Z#{n}Y" }
    end
  end
end
