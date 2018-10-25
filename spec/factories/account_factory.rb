# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { 'Activo' }
    code { '1' }
    imputable { false }
  end
end
