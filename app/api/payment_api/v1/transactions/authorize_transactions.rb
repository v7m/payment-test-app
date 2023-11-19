# frozen_string_literal: true

module PaymentAPI
  module V1
    module Transactions
      class AuthorizeTransactions < Grape::API
        helpers Helpers::TransactionsHelpers

        format :json

        helpers do
          def transaction_params
            {
              merchant_id: params[:merchant_id],
              amount: params[:amount],
              status: params[:status],
              customer_email: params[:customer_email],
              customer_phone: params[:customer_phone]
            }
          end
        end

        resource :authorize_transactions do
          desc "Create authorize transaction"
          params do
            requires :merchant_id, type: String, desc: "merchant_id"
            requires :status, type: String, desc: "status"
            requires :amount, type: Float, desc: "amount"
            requires :customer_email, type: String, desc: "customer email"
            requires :customer_phone, type: String, desc: "customer phone"
          end
          post do
            result = transaction_factory.create_authorize_transaction

            error!({ errors: result.errors }, 422) unless result.success?

            present result.record, with: PaymentAPI::V1::Entities::Transactions::TransactionWithoutReferencedEntity
          end
        end
      end
    end
  end
end
