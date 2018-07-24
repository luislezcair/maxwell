# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    name 'Admin group'
    admin true
  end
end
