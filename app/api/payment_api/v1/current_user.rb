# frozen_string_literal: true

module PaymentAPI
  module V1
    class CurrentUser < Grape::API
      helpers Helpers::AuthenticationHelpers

      format :json

      resource :current_user do
        desc "Get current user"
        get do
          present current_user, with: PaymentAPI::V1::Entities::CurrentUserEntity
        end
      end
    end
  end
end
