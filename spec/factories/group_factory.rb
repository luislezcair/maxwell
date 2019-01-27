# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    name { 'Admin group' }
    admin { true }
  end

  factory :foreign_group, parent: :group do
    name { 'Grupo Marandú' }
    admin { false }
    association :organization, factory: :foreign_organization

    after(:create) do |group|
      # Al crear Permission, estos se agregan solos a cada Grupo a través de
      # GroupPermission.
      create(:permission_technical_service)
      create(:permission_client)

      group.group_permissions.find_each do |gp|
        gp.permission_code = :edit_delete
        gp.save
      end
    end
  end
end
