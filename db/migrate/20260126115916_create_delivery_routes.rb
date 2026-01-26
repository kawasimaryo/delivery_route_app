# frozen_string_literal: true

# 配達ルートテーブル作成マイグレーション
# ユーザーが作成する配達ルートの基本情報を管理
class CreateDeliveryRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :delivery_routes do |t|
      # 所有ユーザー
      t.references :user, null: false, foreign_key: true
      # ルート名（例：「月曜午前ルート」）
      t.string :name, null: false
      # ルートの説明・メモ
      t.text :description
      # 配達予定日
      t.date :date
      # ステータス（0:下書き, 1:確定, 2:完了）
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    # 検索用インデックス
    add_index :delivery_routes, :date
    add_index :delivery_routes, :status
  end
end
