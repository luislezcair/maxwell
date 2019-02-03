# frozen_string_literal: true

# Crear tabla para registrar los eventos de UCRM (UcrmWebhook)
#
class CreateUcrmWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :ucrm_webhooks do |t|
      t.uuid :uuid
      t.string :change_type
      t.string :entity
      t.integer :entity_id
      t.string :event_name
      t.string :status, null: false, default: 'pending'
      t.string :error_msg

      t.timestamps
    end
  end
end
