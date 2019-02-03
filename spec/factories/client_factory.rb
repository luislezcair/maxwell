# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    firstname { 'Stephen' }
    lastname { 'Strange' }
    sequence(:number) { |n| 654_321 + n }
    document_type { :cuit }
    sequence(:document_number) { |n| 23_360_256_499 + n }
    address { 'Av. Siempre Viva 742' }
    country
    province
    sequence(:ucrm_id) { |n| n + 1 }
    sequence(:contabilium_id) { |n| n + 2 }
    organization

    factory :company_client do
      company_name { 'Ksys' }
      document_type { :cuit }
      client_type { :company }
    end

    factory :foreign_client do
      firstname { 'Anthony' }
      lastname { 'Stark' }
      association :organization, factory: :foreign_organization
    end

    factory :client_with_service do
      firstname { 'Citizen' }
      lastname { 'Kane' }
      city
      plan_service
    end

    # Este cliente tiene datos mal cargados y se utiliza para comprobar que un
    # evento de UCRM actualice los atributos.
    factory :client_edit_ucrm_old do
      firstname { 'JON' }
      lastname { 'WASSON' }
      number { 221 }
      document_type { 'dni' }
      document_number { 76_988_455 }
      address { '221b baker street' }
      floor_dept { '221C' }
      ucrm_id { 3 }
      postal_code { '3000' }
      phone { '5493794298092' }
      email { 'jwasson@sherlock.ocm' }
      notes { 'Some observation' }
      association :country, factory: :country_england
      association :organization, factory: :foreign_organization
    end

    # Este es el mismo cliente anterior (mismo ucrm_id) pero con los datos
    # corregidos para comprobar que luego de una actualización tenga estos datos
    # cargados
    factory :client_edit_ucrm_new do
      firstname { 'John' }
      lastname { 'Watson' }
      number { 221 }
      document_type { 'cuit' }
      document_number { 27_769_884_561 }
      address { '221B Baker Street' }
      floor_dept { '2B' }
      ucrm_id { 3 }
      postal_code { 'W3402BKL' }
      phone { '5493794298093' }
      email { 'j.watson@sherlock.com' }
      notes { 'Alguna observación' }
      association :country, factory: :country_arg
      organization

      # Este cliente devuelve error al guardar porque en UCRM no tiene
      # cargado CUIT ni DNI
      factory :client_edit_ucrm_error do
        ucrm_id { 2 }
      end
    end
  end
end
