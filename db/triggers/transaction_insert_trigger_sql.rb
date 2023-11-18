# frozen_string_literal: true

class TransactionInsertTriggerSQL
  def self.create_trigger_function
    <<-SQL
      CREATE OR REPLACE FUNCTION transaction_insert_trigger_function() RETURNS TRIGGER AS $$
      BEGIN
        UPDATE merchants
        SET total_transaction_sum = total_transaction_sum
          + CASE
              WHEN NEW.type = 'Transactions::ChargeTransaction' AND NEW.status = 0
                THEN NEW.amount
              WHEN NEW.type = 'Transactions::RefundTransaction' AND NEW.status = 0
                THEN -NEW.amount
              ELSE 0
            END
        WHERE id = NEW.merchant_id;

        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  def self.create_trigger
    <<-SQL
      CREATE TRIGGER transactions_after_insert_row_trigger
      AFTER INSERT ON transactions
      FOR EACH ROW
      EXECUTE FUNCTION transaction_insert_trigger_function();
    SQL
  end
end
