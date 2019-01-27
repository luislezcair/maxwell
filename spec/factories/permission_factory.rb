# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    factory :permission_technical_service do
      title { 'Servicios Técnicos' }
      category { 'Servicios' }
      code { 'technical_service' }
      organization_filter { true }
    end

    factory :permission_client do
      title { 'Clientes' }
      category { 'Clientes' }
      code { 'clients' }
      organization_filter { true }
    end
  end
end
