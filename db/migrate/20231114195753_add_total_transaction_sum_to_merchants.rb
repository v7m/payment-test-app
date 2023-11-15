class AddTotalTransactionSumToMerchants < ActiveRecord::Migration[7.1]
  def change
    add_column :merchants, :total_transaction_sum, :decimal, precision: 10, scale: 2, null: false, default: 0.0
  end
end
