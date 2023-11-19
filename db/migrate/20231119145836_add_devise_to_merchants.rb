# frozen_string_literal: true

class AddDeviseToMerchants < ActiveRecord::Migration[7.1]
  def up
    change_table :merchants do |t|
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
    end

    add_index :merchants, :reset_password_token, unique: true
  end

  def down
    change_table :merchants do |t|
      t.remove :encrypted_password
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_created_at
    end
  end
end
