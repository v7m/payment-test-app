# frozen_string_literal: true

class TransactionDeleteTriggerSQL
  def self.create_trigger_function
    <<-SQL
      CREATE OR REPLACE FUNCTION transaction_delete_trigger_function() RETURNS TRIGGER AS $$
      BEGIN
        UPDATE merchants
        SET total_transaction_sum = total_transaction_sum
          + CASE
              WHEN OLD.type = 'Transactions::ChargeTransaction' AND OLD.status = 0
                THEN -OLD.amount
              WHEN OLD.type = 'Transactions::RefundTransaction' AND OLD.status = 0
                THEN OLD.amount
              ELSE 0
            END
        WHERE id = OLD.merchant_id;

        RETURN OLD;
      END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  def self.create_trigger
    <<-SQL
      CREATE TRIGGER transactions_after_delete_row_trigger
      AFTER DELETE ON transactions
      FOR EACH ROW
      EXECUTE FUNCTION transaction_delete_trigger_function();
    SQL
  end
end
