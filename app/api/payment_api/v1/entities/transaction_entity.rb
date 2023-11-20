# frozen_string_literal: true

module PaymentAPI
  module V1
    module Entities
      class TransactionEntity < Grape::Entity
        format_with(:float, &:to_f)
        format_with(:iso_timestamp, &:iso8601)

        expose :id, documentation: { type: "String", desc: "ID" }
        expose :merchant_id, documentation: { type: "String", desc: "Merchant ID" }
        expose :referenced_transaction_id, documentation: { type: "String", desc: "Referenced Transaction ID" }
        expose :status, documentation: { type: "String", desc: "Status" }
        expose :customer_email, documentation: { type: "String", desc: "Customer Email" }
        expose :customer_phone, documentation: { type: "String", desc: "Customer Phone" }

        with_options(format_with: :float) do
          expose :amount, documentation: { type: "Float", desc: "Amount" }
        end

        with_options(format_with: :iso_timestamp) do
          expose :created_at
          expose :updated_at
        end
      end
    end
  end
end
