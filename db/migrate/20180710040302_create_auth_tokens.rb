# frozen_string_literal: true

class CreateAuthTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_tokens do |t|
      t.text :token
      t.datetime :expiration_date
      t.timestamps
    end
  end
end
