# frozen_string_literal: true

module PaymentAPI
  module V1
    class Merchants < Grape::API
      format :json

      helpers do
        def merchant
          @merchant ||= Merchant.find(params[:id])
        end
      end

      resource :merchants do
        desc "Get merchants"
        get do
          merchants = Merchant.all

          present merchants, with: PaymentAPI::V1::Entities::MerchantEntity
        end

        desc "Get a merchant by ID"
        params do
          requires :id, type: String, desc: "ID"
        end
        get ":id" do
          present merchant, with: PaymentAPI::V1::Entities::MerchantEntity
        end

        desc "Destroy merchant"
        params do
          requires :id, type: String, desc: "ID"
        end
        delete ":id" do
          merchant&.destroy

          { message: "Recipe deleted!" }
        end
      end
    end
  end
end
