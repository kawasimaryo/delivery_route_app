# frozen_string_literal: true

source "https://rubygems.org"

# ============================================
# コアフレームワーク
# ============================================
# Rails 7.2 - Webアプリケーションフレームワーク
gem "rails", "~> 7.2.3"
# Sprockets - アセットパイプライン管理
gem "sprockets-rails"
# PostgreSQL - リレーショナルデータベース
gem "pg", "~> 1.1"
# Puma - 高性能Webサーバー
gem "puma", ">= 5.0"

# ============================================
# フロントエンド
# ============================================
# Importmap - JavaScriptモジュール管理（バンドラー不要）
gem "importmap-rails"
# Turbo - SPAライクなページ遷移
gem "turbo-rails"
# Stimulus - 軽量JavaScriptフレームワーク
gem "stimulus-rails"

# ============================================
# API・シリアライゼーション
# ============================================
# Jbuilder - JSON APIレスポンス構築
gem "jbuilder"

# ============================================
# キャッシュ・ストレージ（必要に応じて有効化）
# ============================================
# Redis - 高速キャッシュ・ActionCable用
# gem "redis", ">= 4.0.1"
# Kredis - Redisの高レベルAPI
# gem "kredis"

# ============================================
# セキュリティ・認証
# ============================================
# Devise - ユーザー認証システム
gem "devise"
# Devise I18n - Deviseの多言語対応
gem "devise-i18n"

# ============================================
# 地図・ジオコーディング
# ============================================
# Geocoder - 住所から緯度経度を取得
gem "geocoder"

# ============================================
# システム・ユーティリティ
# ============================================
# Windows用タイムゾーンデータ
gem "tzinfo-data", platforms: %i[windows jruby]
# Bootsnap - アプリケーション起動高速化
gem "bootsnap", require: false

# ============================================
# 画像処理（必要に応じて有効化）
# ============================================
# ImageProcessing - Active Storage画像変換
# gem "image_processing", "~> 1.2"

# ============================================
# 開発・テスト環境専用
# ============================================
group :development, :test do
  # Debug - デバッグツール
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  # Brakeman - セキュリティ脆弱性静的解析
  gem "brakeman", require: false
  # RuboCop - Rubyコードスタイルチェック
  gem "rubocop-rails-omakase", require: false
  # Dotenv - 環境変数を.envファイルから読み込み
  gem "dotenv-rails"
  # RSpec - テストフレームワーク
  gem "rspec-rails"
  # FactoryBot - テストデータ作成
  gem "factory_bot_rails"
  # RSpec JUnit Formatter - CI用テスト結果出力
  gem "rspec_junit_formatter"
end

# ============================================
# 開発環境専用
# ============================================
group :development do
  # Web Console - ブラウザ上でのデバッグコンソール
  gem "web-console"
end

gem "net-protocol", "~> 0.2.2"
