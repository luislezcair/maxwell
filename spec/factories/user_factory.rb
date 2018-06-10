# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email 'admin@admin.net'
    name 'Administrator'
    password 'admin-123'

    group
  end
end
