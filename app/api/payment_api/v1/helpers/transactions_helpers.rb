# frozen_string_literal: true

module PaymentAPI::V1::Helpers
  module TransactionsHelpers
    def transaction_factory
      @transaction_factory ||= ::Transactions::CreateTransactionFactory.new(**transaction_params)
    end

    # def transaction_params
    #   @transaction_params ||= {
    #     merchant_id: params[:merchant_id],
    #     status: params[:status],
    #     amount: params[:amount],
    #     customer_email: params[:customer_email],
    #     customer_phone: params[:customer_phone]
    #   }

    #   return @transaction_params if params[:referenced_transaction_id].blank?

    #   @transaction_params.merge!(referenced_transaction_id: params[:referenced_transaction_id])
    # end
  end
end
