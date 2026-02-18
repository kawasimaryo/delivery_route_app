# frozen_string_literal: true

# アプリケーション共通ヘルパー
module ApplicationHelper
  # 配達ステータスに応じたアイコンを返す
  # @param status [String] ステータス名
  # @return [String] アイコン文字
  def status_icon(status)
    case status.to_s
    when "pending"
      "○" # 未配達
    when "delivered"
      "✓" # 配達済み
    when "absent"
      "✗" # 不在
    else
      "?"
    end
  end

  # Google Maps APIキーを取得
  # @return [String, nil] APIキー
  def google_maps_api_key
    ENV["GOOGLE_MAPS_API_KEY"]
  end

  # Google Maps JavaScript APIのスクリプトタグを生成
  # @return [String] scriptタグ
  def google_maps_javascript_tag
    return "" if google_maps_api_key.blank?

    javascript_include_tag(
      "https://maps.googleapis.com/maps/api/js?key=#{google_maps_api_key}&callback=Function.prototype",
      async: true,
      defer: true
    )
  end

  # 配達先データを地図用のJSON形式に変換
  # @param delivery_points [Array<DeliveryPoint>] 配達先リスト
  # @param delivery_route [DeliveryRoute] 配達ルート
  # @return [Array<Hash>] 地図用データ
  def delivery_points_for_map(delivery_points, delivery_route)
    delivery_points.map do |point|
      {
        id: point.id,
        name: point.name,
        address: point.address,
        latitude: point.latitude&.to_f,
        longitude: point.longitude&.to_f,
        status: point.status,
        memo: point.memo,
        editUrl: edit_delivery_route_delivery_point_path(delivery_route, point)
      }
    end
  end
end
