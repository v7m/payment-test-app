# frozen_string_literal: true

class TransactionUpdateTriggerSQL
  def self.create_trigger_function
    <<-SQL
      CREATE OR REPLACE FUNCTION transaction_update_trigger_function() RETURNS TRIGGER AS $$
      BEGIN
        UPDATE merchants
        SET total_transaction_sum = total_transaction_sum
          + CASE
              WHEN NEW.status = 0 AND OLD.status != 0 THEN -- when status becomes "approved"
                CASE
                  WHEN NEW.type = 'Transactions::ChargeTransaction'
                    THEN NEW.amount
                  WHEN NEW.type = 'Transactions::RefundTransaction'
                    THEN -NEW.amount
                END
              WHEN NEW.status != 0 AND OLD.status = 0 THEN -- when status becomes not "approved"
                CASE
                  WHEN NEW.type = 'Transactions::ChargeTransaction'
                    THEN -OLD.amount
                  WHEN NEW.type = 'Transactions::RefundTransaction'
                    THEN OLD.amount
                  ELSE 0
                END
              WHEN (NEW.status = 0 AND OLD.status = 0) AND (NEW.amount != OLD.amount)  THEN  -- when status didn't change
                CASE
                  WHEN NEW.type = 'Transactions::ChargeTransaction'
                    THEN NEW.amount - OLD.amount
                  WHEN NEW.type = 'Transactions::RefundTransaction'
                    THEN -(NEW.amount - OLD.amount)
                  ELSE 0
                END
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
      CREATE TRIGGER transactions_after_update_of_status_amount_row_trigger
      AFTER UPDATE OF status, amount ON transactions
      FOR EACH ROW
      EXECUTE FUNCTION transaction_update_trigger_function();
    SQL
  end
end
