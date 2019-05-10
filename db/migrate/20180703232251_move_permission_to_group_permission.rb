# frozen_string_literal: true

class MovePermissionToGroupPermission < ActiveRecord::Migration[5.2]
  def change
    remove_column :permissions, :permission, :integer, null: false, default: 0
    add_column :group_permissions, :permission_code, :integer, null: false, default: 0
  end
end
