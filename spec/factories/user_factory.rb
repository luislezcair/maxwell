# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'luis' }
    firstname { 'Administrator' }
    lastname { 'Admin' }
    email { 'admin@example.com' }
    password { 'luis-123' }

    group
  end
end
