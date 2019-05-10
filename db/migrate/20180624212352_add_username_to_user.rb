# frozen_string_literal: true

class AddUsernameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string, null: false, default: ''
  end
end
