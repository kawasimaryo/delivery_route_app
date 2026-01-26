# frozen_string_literal: true

# ユーザーテーブル作成マイグレーション
# Devise認証システム用のカラムを含む
class DeviseCreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      # === 認証情報 ===
      # メールアドレス（ログインID）
      t.string :email,              null: false, default: ""
      # 暗号化されたパスワード
      t.string :encrypted_password, null: false, default: ""

      # === パスワードリセット ===
      # パスワードリセット用トークン
      t.string   :reset_password_token
      # トークン送信日時
      t.datetime :reset_password_sent_at

      # === ログイン記憶 ===
      # 「ログインを記憶する」機能用
      t.datetime :remember_created_at

      # === ユーザー情報 ===
      # ユーザー名
      t.string :name, null: false
      # ゲストユーザーフラグ（ゲストログイン機能用）
      t.boolean :guest, default: false, null: false

      t.timestamps null: false
    end

    # インデックス
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
