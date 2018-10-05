# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { '10 Positivo' }
    account_code { '1.2.3.4' }
    concept_id { 10 }
    ucrm_id { 10 }
  end
end
