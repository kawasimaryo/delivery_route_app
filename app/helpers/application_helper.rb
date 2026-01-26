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
end
