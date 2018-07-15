# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    firstname 'Stephen'
    lastname 'Strange'
    number '987654321'
    document_number 23_360_256_499
    city
  end
end
