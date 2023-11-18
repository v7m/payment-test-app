# frozen_string_literal: true

module Transactions
  class CreateTransactionFactory
    def initialize(merchant_id:, referenced_transaction_id: nil, status:, amount: nil, customer_email:, customer_phone: nil)
      @merchant_id = merchant_id
      @referenced_transaction_id = referenced_transaction_id
      @status = status
      @amount = amount
      @customer_email = customer_email
      @customer_phone = customer_phone
    end

    def create_authorize_transaction
      CreateAuthorizeTransactionService.call(**build_params)
    end

    def create_charge_transaction
      CreateChargeTransactionService.call(**build_params)
    end

    def create_reversal_transaction
      CreateReversalTransactionService.call(**build_params)
    end

    def create_refund_transaction
      CreateRefundTransactionService.call(**build_params)
    end

    private

    def build_params
      {
        merchant_id: @merchant_id,
        referenced_transaction_id: @referenced_transaction_id,
        status: @status,
        amount: @amount,
        customer_email: @customer_email,
        customer_phone: @customer_phone
      }
    end
  end
end
