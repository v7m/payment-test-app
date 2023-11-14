class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.belongs_to :merchant, type: :uuid, foreign_key: true
      t.references :referenced_transaction, type: :uuid, foreign_key: { to_table: :transactions }
      t.string :type
      t.decimal :amount, precision: 10, scale: 2
      t.integer :status
      t.string :customer_email, null: false, default: ""
      t.string :customer_phone

      t.timestamps
    end
  end
end
