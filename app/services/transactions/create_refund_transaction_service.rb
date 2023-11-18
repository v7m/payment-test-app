# frozen_string_literal: true

module Transactions
  class CreateRefundTransactionService < CreateTransactionService
    TRANSACTION_TYPE = "Transactions::RefundTransaction"

    def call
      super { referenced_transaction.refunded! }
    end

    private

    def transaction_type
      TRANSACTION_TYPE
    end
  end
end
