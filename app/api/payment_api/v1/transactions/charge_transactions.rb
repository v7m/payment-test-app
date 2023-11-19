# frozen_string_literal: true

module PaymentAPI
  module V1
    module Transactions
      class ChargeTransactions < Grape::API
        helpers Helpers::TransactionsHelpers

        format :json

        helpers do
          def transaction_params
            {
              merchant_id: params[:merchant_id],
              referenced_transaction_id: params[:referenced_transaction_id],
              amount: params[:amount],
              status: params[:status],
              customer_email: params[:customer_email],
              customer_phone: params[:customer_phone]
            }
          end
        end

        resource :charge_transactions do
          desc "Create charge transaction"
          params do
            requires :merchant_id, type: String, desc: "merchant_id"
            requires :referenced_transaction_id, type: String, desc: "referenced_transaction_id"
            requires :status, type: String, desc: "status"
            requires :amount, type: Float, desc: "amount"
            requires :customer_email, type: String, desc: "customer email"
            requires :customer_phone, type: String, desc: "customer phone"
          end
          post do
            result = transaction_factory.create_charge_transaction

            error!({ errors: result.errors }, 422) unless result.success?

            present result.record, with: PaymentAPI::V1::Entities::Transactions::TransactionWithReferencedEntity
          end
        end
      end
    end
  end
end
