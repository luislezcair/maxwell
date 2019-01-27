# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    firstname { 'Stephen' }
    lastname { 'Strange' }
    sequence(:number) { |n| 654_321 + n }
    document_type { :cuit }
    sequence(:document_number) { |n| 23_360_256_499 + n }
    address { 'Av. Siempre Viva 742' }
    country
    province
    sequence(:ucrm_id) { |n| n + 1 }
    sequence(:contabilium_id) { |n| n + 2 }
    organization

    factory :company_client do
      company_name { 'Ksys' }
      document_type { :cuit }
      client_type { :company }
    end

    factory :foreign_client do
      firstname { 'Anthony' }
      lastname { 'Stark' }
      association :organization, factory: :foreign_organization
    end
  end
end
