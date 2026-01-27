# Puma設定ファイル
# 詳細: https://puma.io/puma/Puma/DSL.html

# === スレッド設定 ===
# スレッド数はRAILS_MAX_THREADS環境変数で設定可能
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# === ポート設定 ===
# HerokuはPORT環境変数でポートを指定
port ENV.fetch("PORT", 3000)

# === 本番環境設定 ===
environment ENV.fetch("RAILS_ENV", "development")

# === ワーカー設定（本番環境用） ===
# WEB_CONCURRENCYでワーカー数を指定（Heroku推奨）
workers ENV.fetch("WEB_CONCURRENCY", 2) if ENV["RAILS_ENV"] == "production"

# === アプリケーション事前読み込み ===
# ワーカー使用時はpreload_appでメモリ効率を向上
preload_app! if ENV["RAILS_ENV"] == "production"

# === ワーカー起動時のコールバック ===
on_worker_boot do
  # ワーカー毎にDB接続を確立
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# === 開発環境設定 ===
# bin/rails restartコマンドでの再起動を許可
plugin :tmp_restart

# === PIDファイル ===
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
