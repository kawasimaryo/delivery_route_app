# 配達ルート最適化アプリ (Delivery Route App)

配達員の効率的なルート計画を支援するWebアプリケーションです。

## 技術スタック

- **フレームワーク**: Ruby on Rails 7.2
- **データベース**: PostgreSQL
- **フロントエンド**: Hotwire (Turbo + Stimulus)
- **Ruby**: 3.3.3

## セットアップ

### 必要な環境

- Ruby 3.3.3
- PostgreSQL 14以上
- Node.js（任意）

### インストール手順

```bash
# リポジトリをクローン
git clone <repository-url>
cd delivery_route_app

# 依存関係をインストール
bundle install

# データベースをセットアップ
rails db:create
rails db:migrate

# 開発サーバーを起動
rails server
```

### 環境変数

本番環境では以下の環境変数を設定してください：

| 変数名 | 説明 |
|--------|------|
| `DELIVERY_ROUTE_APP_DATABASE_PASSWORD` | PostgreSQLパスワード |
| `RAILS_MASTER_KEY` | credentials暗号化キー |

## 開発

```bash
# サーバー起動
rails server

# コンソール起動
rails console

# データベースマイグレーション
rails db:migrate
```

## ライセンス

このプロジェクトは [MIT License](LICENSE) の下で公開されています。
