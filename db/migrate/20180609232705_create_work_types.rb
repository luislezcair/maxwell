# frozen_string_literal: true

class CreateWorkTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :work_types do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
