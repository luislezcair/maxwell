# frozen_string_literal: true

class CreateSurgeProtectorSetupTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :surge_protector_setup_types do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
