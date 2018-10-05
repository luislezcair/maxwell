# frozen_string_literal: true

FactoryBot.define do
  factory :corporate_cellphone do
    phone { '08005559876' }

    factory :cellphone_with_sequence do
      sequence(:phone) { |n| "379 429809#{n}" }
    end
  end
end
