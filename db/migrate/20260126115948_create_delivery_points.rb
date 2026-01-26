# frozen_string_literal: true

# 配達先テーブル作成マイグレーション
# 各配達ルートに含まれる配達先（ポイント）を管理
class CreateDeliveryPoints < ActiveRecord::Migration[7.2]
  def change
    create_table :delivery_points do |t|
      # 所属する配達ルート
      t.references :delivery_route, null: false, foreign_key: true
      # 配達先名（例：「山田様宅」）
      t.string :name, null: false
      # 住所
      t.string :address
      # 緯度（地図表示・ルート計算用）
      t.decimal :latitude, precision: 10, scale: 7
      # 経度（地図表示・ルート計算用）
      t.decimal :longitude, precision: 10, scale: 7
      # ルート内の順番（並び替え用）
      t.integer :position, default: 0, null: false
      # 配達メモ（注意事項など）
      t.text :memo
      # ステータス（0:未配達, 1:配達済み, 2:不在）
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    # 並び順でのソート用インデックス
    add_index :delivery_points, [:delivery_route_id, :position]
    add_index :delivery_points, :status
  end
end
