# frozen_string_literal: true

class CreateGroupPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :group_permissions do |t|
      t.integer :group_id
      t.integer :permission_id
    end

    add_index :group_permissions, [:group_id, :permission_id], unique: true
  end
end
