# frozen_string_literal: true

module PaymentAPI::V1::Helpers
  module AuthenticationHelpers
    def current_user
      warden = env["warden"]
      @current_user ||= (warden.user(scope: :admin) || warden.user(scope: :merchant_admin))
    end

    def authenticate!
      error!("Unauthorized", 401) unless current_user
    end
  end
end
