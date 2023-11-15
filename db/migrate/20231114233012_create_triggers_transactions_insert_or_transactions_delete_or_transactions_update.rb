require_relative "../triggers/transaction_insert_trigger_sql"
require_relative "../triggers/transaction_delete_trigger_sql"
require_relative "../triggers/transastion_update_trigger_sql"

class CreateTriggersTransactionsInsertOrTransactionsDeleteOrTransactionsUpdate < ActiveRecord::Migration[7.1]
  def up
    execute TransactionInsertTriggerSQL.create_trigger_function
    execute TransactionInsertTriggerSQL.create_trigger

    execute TransactionDeleteTriggerSQL.create_trigger_function
    execute TransactionDeleteTriggerSQL.create_trigger

    execute TransactionUpdateTriggerSQL.create_trigger_function
    execute TransactionUpdateTriggerSQL.create_trigger
  end

  def down
    execute "DROP TRIGGER IF EXISTS transactions_after_insert_row_trigger ON transactions;"
    execute "DROP FUNCTION IF EXISTS transaction_insert_trigger_function();"

    execute "DROP TRIGGER IF EXISTS transactions_after_delete_row_trigger ON transactions;"
    execute "DROP FUNCTION IF EXISTS transaction_delete_trigger_function();"

    execute "DROP TRIGGER IF EXISTS transactions_after_update_of_status_amount_row_trigger ON transactions;"
    execute "DROP FUNCTION IF EXISTS transaction_update_trigger_function();"
  end
end
