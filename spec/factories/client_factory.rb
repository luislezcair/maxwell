# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    firstname { 'Stephen' }
    lastname { 'Strange' }
    number { 654_321 }
    document_type { :cuit }
    document_number { 23_360_256_499 }
    country
    province
    ucrm_id { 1 }
    contabilium_id { 2 }
    organization
  end
end
