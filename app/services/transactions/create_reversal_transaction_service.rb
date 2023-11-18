# frozen_string_literal: true

module Transactions
  class CreateReversalTransactionService < CreateTransactionService
    TRANSACTION_TYPE = "Transactions::ReversalTransaction"

    def call
      super { referenced_transaction.reversed! }
    end

    private

    def transaction_type
      TRANSACTION_TYPE
    end

    def validate_amount!(amount)
      return if amount.blank?

      raise ArgumentError, "amount is not allowed for ReversalTransaction"
    end
  end
end
