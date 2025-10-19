# stzky-compose

山岸和利の個人宅に配置しているサーバーで動かすための、セルフホストサービス向けのDocker Compose設定ファイル集です。

## 概要

このリポジトリには、簡単にデプロイ・メンテナンスできるように設計された、様々なセルフホストサービス向けのDocker Compose設定ファイルが含まれています。

## サービス

### Caddy

Caddyを使用した自動HTTPS対応のWebサーバー。

- **場所**: `caddy/`
- **イメージ**: caddy:2.10.2
- **ポート**: 80, 443, 2019 (管理用)
- **機能**: 
  - Let's Encryptによる自動HTTPS
  - リバースプロキシ機能
  - Prometheus認証

### Grafana

Grafana、Prometheus、Alloy、各種エクスポーターを含む完全な監視スタック。

- **場所**: `grafana/`
- **サービス**:
  - Grafana (可視化)
  - Prometheus (メトリクスストレージ)
  - Alloy (テレメトリコレクター)
  - Node Exporter (システムメトリクス)
  - SNMP Exporter (SNMPデバイスメトリクス)
  - PostgreSQL (データベース)
  - Valkey/Redis (キャッシュ)
- **ポート**:
  - 3000 (Grafana)
  - 9090 (Prometheus)

### Immich

セルフホスト型の写真・動画管理ソリューション。

- **場所**: `immich/`
- **サービス**:
  - Immich Server
  - Immich Machine Learning
  - PostgreSQL (ベクトルサポート付き)
  - Valkey/Redis
- **ポート**:
  - 2283 (メインサーバー)
  - 8081, 8082 (メトリクス用、公開を前提としていません)

### Uptime Kuma

稼働時間監視のためのセルフホスト型監視ツール。

- **場所**: `uptime-kuma/`
- **サービス**:
  - Uptime Kuma
  - MariaDB
- **ポート**: 3001

## 使い方

### 前提条件

- Docker
- Docker Compose
- Go 1.24.3 (yamlfmtツール用)

### デプロイ

各サービスは次のようなコマンドで個別にデプロイできます。

```bash
cd <サービスディレクトリ>
docker compose up -d
```

例えば、Grafanaをデプロイする場合は次のようにします。

```bash
cd grafana
docker compose up -d
```

### 設定

各サービスには環境変数が必要です。各サービスディレクトリに`.env`ファイルを作成し、必要な変数を設定してください。必要な環境変数については、各サービスの`compose.yaml`ファイルを参照してください。

### サービスの停止

サービスを停止するには次のようなコマンドを実行します。

```bash
cd <サービスディレクトリ>
docker compose down
```

## 開発

### YAMLフォーマット

このプロジェクトでは、YAMLファイルのフォーマットに`yamlfmt`を使用しています。このツールは`go.mod`で指定されています:

```bash
go tool yamlfmt
```

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています。詳細は[LICENSE](LICENSE)ファイルを参照してください。

## 著者

Yamagishi Kazutoshi
