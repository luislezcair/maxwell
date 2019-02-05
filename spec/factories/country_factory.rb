# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    sequence(:name) { |n| "Argentina #{n}" }
    sequence(:ucrm_id) { |n| n + 1 }

    factory :country_arg do
      name { 'Argentina' }
      contabilium_id { 10 }
      ucrm_id { 26 }
    end

    factory :country_england do
      name { 'United Kingdom' }
      contabilium_id { 130 }
      ucrm_id { 93 }
    end
  end
end
