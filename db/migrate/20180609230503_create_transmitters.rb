# frozen_string_literal: true

class CreateTransmitters < ActiveRecord::Migration[5.2]
  def change
    create_table :transmitters do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
