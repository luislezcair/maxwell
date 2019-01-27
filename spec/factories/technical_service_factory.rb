# frozen_string_literal: true

# Required attributes:
#   * Rmtm work_types
#   * Rmtm corporate_cellphones
#   * Rmtm technicians
#   * R client
#   * R city
#   * R ground_wire_setup_type
#   * R surge_protector_setup_type
#   * work_order_number
#   * arrival_time
#   * departure_time

FactoryBot.define do
  factory :technical_service do
    transient do
      work_types_count { 2 }
      cellphones_count { 2 }
      technicians_count { 2 }
    end

    arrival_time { Time.new(2018, 6, 11, 15, 0, 0).in_time_zone }
    datetime { Time.new(2018, 6, 11, 22, 0, 0).in_time_zone }
    departure_time { Time.new(2018, 6, 11, 16, 0, 0).in_time_zone }
    plug_adapter_quantity { 10 }
    work_order_number { 666 }

    # Relaciones requeridas de acuerdo al formulario de GDocs:
    city
    client
    organization
    ground_wire_setup_type
    surge_protector_setup_type

    after(:build) do |service, evaluator|
      service.work_types << build_list(:work_type_with_sequence,
                                       evaluator.work_types_count)
      service.corporate_cellphones << build_list(:cellphone_with_sequence,
                                                 evaluator.cellphones_count)
      service.technicians << build_list(:technician_with_sequence,
                                        evaluator.technicians_count)
    end

    factory :foreign_technical_service do
      work_order_number { 777 }
      association :organization, factory: :foreign_organization
      association :client, factory: :foreign_client
    end
  end
end
