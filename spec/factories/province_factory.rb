# frozen_string_literal: true

FactoryBot.define do
  factory :province do
    sequence(:name) { |n| "Corrientes #{n}" }
    country

    factory :province_misiones do
      name { 'Misiones' }
      association :country, factory: :country_arg
    end
  end
end
