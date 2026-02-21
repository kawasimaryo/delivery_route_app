# frozen_string_literal: true

Rails.application.routes.draw do
  # === 認証（Devise） ===
  devise_for :users

  # === ゲストログイン ===
  post "guest_login", to: "sessions/guest#create"

  # === 配達ルート ===
  resources :delivery_routes do
    member do
      post :optimize
    end
    # === 配達先（ネストリソース） ===
    resources :delivery_points, except: [ :index, :show ] do
      member do
        patch :update_status
      end
    end
  end

  # === トップページ ===
  root "home#index"

  # === ヘルスチェック ===
  get "up" => "rails/health#show", as: :rails_health_check

  # === PWA ===
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
