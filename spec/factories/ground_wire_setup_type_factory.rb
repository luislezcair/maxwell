# frozen_string_literal: true

FactoryBot.define do
  factory :ground_wire_setup_type do
    sequence(:name) { |n| "Sin cable a tierra #{n}" }
  end
end
