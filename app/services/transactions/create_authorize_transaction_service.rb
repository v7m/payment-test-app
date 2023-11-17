module Transactions
  class CreateAuthorizeTransactionService < CreateTransactionService
    TRANSACTION_TYPE = "Transactions::AuthorizeTransaction".freeze

    private

    def transaction_type
      TRANSACTION_TYPE
    end

    def referenced_transaction
      @referenced_transaction ||= nil
    end

    def referenced_transaction_status_permitted?
      nil
    end

    def valid_transaction_status
      @valid_transaction_status ||= @status
    end

    def validate_referenced_transaction_id_param!(referenced_transaction_id)
      if referenced_transaction_id.present?
        raise ArgumentError.new("referenced_transaction_id is not allowed for AuthorizeTransaction")
      end
    end
  end
end
