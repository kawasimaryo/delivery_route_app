# frozen_string_literal: true

# 配達ルートモデル
# 配達員が1日の配達で回るルートを管理
class DeliveryRoute < ApplicationRecord
  # === アソシエーション ===
  belongs_to :user
  has_many :delivery_points, dependent: :destroy

  # === ステータス定義 ===
  # draft: 下書き - 編集中のルート
  # confirmed: 確定 - 配達予定のルート
  # completed: 完了 - 配達が終了したルート
  enum :status, {
    draft: 0,
    confirmed: 1,
    completed: 2
  }, prefix: true

  # === バリデーション ===
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :status, presence: true

  # === スコープ ===
  # 日付の新しい順
  scope :recent, -> { order(date: :desc, created_at: :desc) }
  # 特定の日付のルート
  scope :on_date, ->(date) { where(date: date) }
  # 今日のルート
  scope :today, -> { on_date(Date.current) }

  # === インスタンスメソッド ===

  # 配達先の総数を取得
  # @return [Integer]
  def total_points
    delivery_points.count
  end

  # 配達済みの配達先数を取得
  # @return [Integer]
  def delivered_points
    delivery_points.status_delivered.count
  end

  # 配達進捗率を取得（パーセント）
  # @return [Float]
  def progress_percentage
    return 0.0 if total_points.zero?

    (delivered_points.to_f / total_points * 100).round(1)
  end
end
