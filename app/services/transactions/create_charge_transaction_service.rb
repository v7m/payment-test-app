# frozen_string_literal: true

module Transactions
  class CreateChargeTransactionService < CreateTransactionService
    TRANSACTION_TYPE = "Transactions::ChargeTransaction"

    private

    def transaction_type
      TRANSACTION_TYPE
    end
  end
end
