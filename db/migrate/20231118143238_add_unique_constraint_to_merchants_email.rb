class AddUniqueConstraintToMerchantsEmail < ActiveRecord::Migration[7.1]
  def change
    add_index :merchants, :email, unique: true
  end
end
