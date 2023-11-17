module Transactions
  class CreateChargeTransactionService < CreateTransactionService
    TRANSACTION_TYPE = "Transactions::ChargeTransaction".freeze

    private

    def transaction_type
      TRANSACTION_TYPE
    end
  end
end
