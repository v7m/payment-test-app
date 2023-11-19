# frozen_string_literal: true

module PaymentAPI
  module V1
    module Entities
      module Transactions
        class TransactionWithReferencedEntity < TransactionWithoutReferencedEntity
          expose :referenced_transaction_id, documentation: { type: "String", desc: "Referenced Transaction ID" }
        end
      end
    end
  end
end
