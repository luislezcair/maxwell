# frozen_string_literal: true

FactoryBot.define do
  factory :work_type do
    name { 'Tipo de trabajo ZZZ' }

    factory :work_type_with_sequence do
      sequence(:name) { |n| "Tipo de trabajo X#{n}" }
    end
  end
end
