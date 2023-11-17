module Transactions
  class CreateRefundTransactionService < CreateTransactionService
    TRANSACTION_TYPE = "Transactions::RefundTransaction".freeze

    def call
      super { referenced_transaction.refunded! }
    end

    private

    def transaction_type
      TRANSACTION_TYPE
    end
  end
end
