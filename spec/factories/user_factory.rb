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

  factory :foreign_user, parent: :user do
    username { 'marandu' }
    firstname { 'Marandú' }
    lastname { 'Marando' }
    email { 'marandu@marandu.com.ar' }
    password { 'marandu-123' }

    association :group, factory: :foreign_group
  end
end
