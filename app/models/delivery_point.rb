# frozen_string_literal: true

# 配達先モデル
# 配達ルート内の各配達ポイント（届け先）を管理
class DeliveryPoint < ApplicationRecord
  # === アソシエーション ===
  belongs_to :delivery_route

  # === ステータス定義 ===
  # pending: 未配達 - まだ配達していない
  # delivered: 配達済み - 正常に配達完了
  # absent: 不在 - 不在のため配達できず
  enum :status, {
    pending: 0,
    delivered: 1,
    absent: 2
  }, prefix: true

  # === バリデーション ===
  validates :name, presence: true, length: { maximum: 100 }
  validates :address, length: { maximum: 500 }
  validates :memo, length: { maximum: 1000 }
  validates :latitude, numericality: {
    greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90,
    allow_nil: true
  }
  validates :longitude, numericality: {
    greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180,
    allow_nil: true
  }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true

  # === スコープ ===
  # 順番通りに並べる
  scope :ordered, -> { order(:position) }
  # 未配達のみ
  scope :not_delivered, -> { where.not(status: :delivered) }

  # === コールバック ===
  before_validation :set_default_position, on: :create

  # === インスタンスメソッド ===

  # 座標が設定されているか
  # @return [Boolean]
  def geocoded?
    latitude.present? && longitude.present?
  end

  # 配達済みとしてマーク
  def mark_as_delivered!
    update!(status: :delivered)
  end

  # 不在としてマーク
  def mark_as_absent!
    update!(status: :absent)
  end

  private

  # デフォルトの並び順を設定
  def set_default_position
    return if position.present?
    return unless delivery_route

    max_position = delivery_route.delivery_points.maximum(:position) || -1
    self.position = max_position + 1
  end
end
