# frozen_string_literal: true

class RemoveFieldsFromBillingExport < ActiveRecord::Migration[5.2]
  def change
    remove_column :billing_exports, :user_id, :integer
    remove_column :billing_exports, :file_format, :integer, default: 0, null: false
    add_column :billing_exports, :background_job_id, :integer
  end
end
