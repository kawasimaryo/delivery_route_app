# frozen_string_literal: true

# アプリケーション共通コントローラー
# 全コントローラーの基底クラス
class ApplicationController < ActionController::Base
  # モダンブラウザのみ許可
  allow_browser versions: :modern

  # === Devise認証 ===
  # 全ページでログイン必須（個別に解除可能）
  before_action :authenticate_user!

  # Deviseで追加パラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Deviseの許可パラメータ設定
  # サインアップ・アカウント更新時にnameを許可
  def configure_permitted_parameters
    # サインアップ時
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    # アカウント更新時
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
