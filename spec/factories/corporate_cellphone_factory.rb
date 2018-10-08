# frozen_string_literal: true

FactoryBot.define do
  factory :corporate_cellphone do
    phone { 8_005_559_876 }

    factory :cellphone_with_sequence do
      sequence(:phone) { |n| 379_429_809 + n }
    end
  end
end
