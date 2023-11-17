module Transactions
  class CreateReversalTransactionService < CreateTransactionService
    TRANSACTION_TYPE = "Transactions::ReversalTransaction".freeze

    def call
      super { referenced_transaction.reversed! }
    end

    private

    def transaction_type
      TRANSACTION_TYPE
    end

    def validate_amount!(amount)
      raise ArgumentError.new("amount is not allowed for ReversalTransaction") if amount.present?
    end
  end
end
