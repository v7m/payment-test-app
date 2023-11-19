# frozen_string_literal: true

module PaymentAPI
  module V1
    module Entities
      class MerchantEntity < Grape::Entity
        format_with(:iso_timestamp, &:iso8601)

        expose :id, documentation: { type: "String", desc: "ID" }
        expose :status, documentation: { type: "String", desc: "Status" }
        expose :email, documentation: { type: "String", desc: "Email" }
        expose :name, documentation: { type: "String", desc: "Name" }

        with_options(format_with: :iso_timestamp) do
          expose :created_at
          expose :updated_at
        end
      end
    end
  end
end
