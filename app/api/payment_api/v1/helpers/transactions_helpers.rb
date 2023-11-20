# frozen_string_literal: true

module PaymentAPI::V1::Helpers
  module TransactionsHelpers
    def transaction_factory
      @transaction_factory ||= ::Transactions::CreateTransactionFactory.new(**transaction_params)
    end
  end
end
