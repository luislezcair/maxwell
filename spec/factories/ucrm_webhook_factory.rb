# frozen_string_literal: true

FactoryBot.define do
  factory :ucrm_webhook do
    uuid { '61167377-e29f-4e37-a8b1-0f782e3918d0' }

    factory :webhook_test do
      change_type { 'test' }
      entity { 'webhook' }
      entity_id { 1 }
      event_name { 'test' }
    end

    factory :webhook_client do
      change_type { 'insert' }
      entity { 'client' }
      event_name { 'client.add' }

      factory :webhook_client_add do
        entity_id { 1 }
      end

      factory :webhook_client_add_error do
        entity_id { 2 }
      end

      factory :webhook_client_edit do
        change_type { 'edit' }
        event_name { 'client.edit' }
        entity_id { 3 }
      end

      factory :webhook_client_edit_error do
        change_type { 'edit' }
        event_name { 'client.edit' }
        entity_id { 2 }
      end

      factory :webhook_client_edit_not_existant do
        change_type { 'edit' }
        event_name { 'client.edit' }
        entity_id { 1 }
      end
    end
  end
end
