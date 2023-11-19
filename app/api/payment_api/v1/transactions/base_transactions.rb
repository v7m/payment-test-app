# frozen_string_literal: true

module PaymentAPI
  module V1
    module Transactions
      class BaseTransactions < Grape::API
        helpers Helpers::TransactionsHelpers

        def self.inherited(subclass)
          super

          subclass.instance_eval do
            before do
              merchant = Merchant.find_by(id: params[:merchant_id])

              error!({ errors: "Merchant not exists" }, 422) if merchant.blank?
              error!({ errors: "Merchant is in inactive state" }, 422) if merchant.inactive?
            end
          end
        end
      end
    end
  end
end
