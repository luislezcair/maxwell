# frozen_string_literal: true

FactoryBot.define do
  factory :surge_protector_setup_type do
    sequence(:name) { |n| "UPS infinitas horas de duración #{n}" }
  end
end
