# frozen_string_literal: true

FactoryBot.define do
  factory :province do
    sequence(:name) { |n| "Corrientes #{n}" }
    country

    factory :province_misiones do
      name { 'Misiones' }
      contabilium_id { 14 }
    end

    factory :province_caba do
      name { 'Ciudad de Buenos Aires' }
      contabilium_id { 2 }
    end
  end
end
