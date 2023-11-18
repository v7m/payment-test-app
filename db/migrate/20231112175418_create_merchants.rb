class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :name, null: false, default: ""
      t.string :description
      t.string :email, null: false, default: ""
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
