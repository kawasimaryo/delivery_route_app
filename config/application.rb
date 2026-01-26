# frozen_string_literal: true

require_relative "boot"

require "rails"
# 使用するRailsフレームワークを選択
require "active_model/railtie"    # モデルのバリデーション・コールバック
require "active_job/railtie"      # バックグラウンドジョブ処理
require "active_record/railtie"   # データベースORM
require "active_storage/engine"   # ファイルアップロード
require "action_controller/railtie" # コントローラー
require "action_mailer/railtie"   # メール送信
require "action_mailbox/engine"   # メール受信
require "action_text/engine"      # リッチテキスト
require "action_view/railtie"     # ビューテンプレート
require "action_cable/engine"     # WebSocket
# require "rails/test_unit/railtie" # テスト（RSpecを使用するため無効化）

# Gemfileに記載されたgemを環境別に読み込む
Bundler.require(*Rails.groups)

module DeliveryRouteApp
  # 配達ルート最適化アプリケーション
  # 配達員の効率的なルート計画を支援するシステム
  class Application < Rails::Application
    # Rails 7.2のデフォルト設定を使用
    config.load_defaults 7.2

    # libディレクトリの自動読み込み設定
    # assets, tasksは除外（.rbファイルを含まないため）
    config.autoload_lib(ignore: %w[assets tasks])

    # タイムゾーンを日本時間に設定
    config.time_zone = "Tokyo"

    # デフォルトのロケールを日本語に設定
    config.i18n.default_locale = :ja

    # システムテストファイルを生成しない
    config.generators.system_tests = nil

    # ジェネレーター設定
    config.generators do |g|
      g.skip_routes true        # ルート自動追加を無効化
      g.helper false            # ヘルパーファイル生成を無効化
      g.assets false            # アセットファイル生成を無効化
      g.test_framework :rspec   # テストフレームワークにRSpecを使用
    end
  end
end
