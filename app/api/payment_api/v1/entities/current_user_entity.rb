# frozen_string_literal: true

module PaymentAPI
  module V1
    module Entities
      class CurrentUserEntity < Grape::Entity
        expose :id, documentation: { type: "String", desc: "ID" }
        expose :email, documentation: { type: "String", desc: "Email" }
        expose :name, documentation: { type: "String", desc: "Name" }
        expose :role do |instance, _|
          if instance.is_a?(Admin)
            "admin"
          elsif instance.is_a?(Merchant)
            "merchant"
          end
        end
      end
    end
  end
end
