# frozen_string_literal: true

class CreateGroundWireSetupTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ground_wire_setup_types do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
