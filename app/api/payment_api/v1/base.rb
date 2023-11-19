# frozen_string_literal: true

module PaymentAPI
  module V1
    class Base < Grape::API
      version "v1", using: :path
      format :json

      mount PaymentAPI::V1::Transactions::AuthorizeTransactions
      mount PaymentAPI::V1::Transactions::ChargeTransactions
      mount PaymentAPI::V1::Transactions::ReversalTransactions
      mount PaymentAPI::V1::Transactions::RefundTransactions
    end
  end
end
