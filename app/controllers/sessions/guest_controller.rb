# frozen_string_literal: true

module Sessions
  # ゲストログインコントローラー
  # ワンクリックでゲストユーザーとしてログインする機能を提供
  class GuestController < ApplicationController
    # 未ログインでもアクセス可能
    skip_before_action :authenticate_user!

    # ゲストログイン処理
    # POST /guest_login
    def create
      user = User.guest
      sign_in(user)

      redirect_to delivery_routes_path, notice: "ゲストユーザーとしてログインしました。"
    end
  end
end
