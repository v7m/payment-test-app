# frozen_string_literal: true

Rails.application.routes.draw do
  mount PaymentAPI::Base => "/"

  root "homepage#index"

  devise_for :admins
  devise_scope :admin do
    get "/admins/sign_out" => "devise/sessions#destroy"
  end

  devise_for :merchant_admins, class_name: "Merchant"
  devise_scope :merchant_admin do
    get "/merchant_admins/sign_out" => "devise/sessions#destroy"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "/*path" => "homepage#index", constraints: lambda { |request|
    !request.xhr? && request.format.html? &&
      !(request.path.start_with?("/admins") || request.path.start_with?("/merchant_admins"))
  }
end
