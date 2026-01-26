# frozen_string_literal: true

# ユーザーモデル
# 認証・認可とユーザー情報を管理
class User < ApplicationRecord
  # === Devise モジュール ===
  # :database_authenticatable - パスワード認証
  # :registerable - ユーザー登録
  # :recoverable - パスワードリセット
  # :rememberable - ログイン状態の保持
  # :validatable - メール・パスワードのバリデーション
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # === アソシエーション ===
  has_many :delivery_routes, dependent: :destroy

  # === バリデーション ===
  validates :name, presence: true, length: { maximum: 50 }

  # === ゲストユーザー機能 ===

  # ゲストユーザーを作成または取得
  # @return [User] ゲストユーザー
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
      user.guest = true
    end
  end

  # ゲストユーザーかどうか判定
  # @return [Boolean]
  def guest_user?
    guest?
  end
end
