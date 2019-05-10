# frozen_string_literal: true

class CreateBackgroundJob < ActiveRecord::Migration[5.2]
  def change
    create_table :background_jobs do |t|
      t.string :job_id
      t.string :detailed_status
      t.string :error_msg
      t.integer :status, null: false, default: 0
      t.integer :progress, default: 0
      t.references :job_item, polymorphic: true

      t.timestamps
    end
  end
end
