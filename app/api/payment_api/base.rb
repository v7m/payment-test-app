# frozen_string_literal: true

module PaymentAPI
  class Base < Grape::API
    prefix "api"
    mount PaymentAPI::V1::Base

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      rack_response({
        status: e.status,
        error_msg: e.message
      }.to_json, 400)
    end
  end
end
