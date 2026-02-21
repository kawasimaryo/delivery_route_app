# frozen_string_literal: true

# トップページコントローラー
# ログイン状態に応じてランディングページまたはダッシュボードを表示
class HomeController < ApplicationController
  # ログイン前でもアクセス可能
  skip_before_action :authenticate_user!, only: [ :index ]

  # トップページ
  # GET /
  def index
    # ログイン済みの場合は配達ルート一覧へリダイレクト
    if user_signed_in?
      redirect_to delivery_routes_path
    end
    # 未ログインの場合はランディングページを表示
  end
end
