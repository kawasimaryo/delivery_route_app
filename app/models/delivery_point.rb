# frozen_string_literal: true

# 配達先モデル
class DeliveryPoint < ApplicationRecord
  belongs_to :delivery_route

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  enum :status, {
    pending: 0,
    delivered: 1,
    absent: 2
  }, prefix: true

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

  scope :ordered, -> { order(:position) }
  scope :not_delivered, -> { where.not(status: :delivered) }

  before_validation :set_default_position, on: :create

  def geocoded?
    latitude.present? && longitude.present?
  end

  def mark_as_delivered!
    update!(status: :delivered)
  end

  def mark_as_absent!
    update!(status: :absent)
  end

  private

  def set_default_position
    return if position.present?
    return unless delivery_route

    max_position = delivery_route.delivery_points.maximum(:position) || -1
    self.position = max_position + 1
  end
end
