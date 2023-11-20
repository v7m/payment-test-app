# frozen_string_literal: true

module PaymentAPI
  module V1
    class Merchants < Grape::API
      helpers Helpers::AuthenticationHelpers

      format :json

      before do
        authenticate!
      end

      helpers do
        def merchant
          @merchant ||= Merchant.find(params[:id])
        end
      end

      resource :merchants do # rubocop:disable Metrics/BlockLength
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

        route_param :id do
          resource :transactions do
            desc "Get all transactions"
            get do
              present merchant.transactions, with: PaymentAPI::V1::Entities::TransactionEntity
            end
          end
        end
      end
    end
  end
end
