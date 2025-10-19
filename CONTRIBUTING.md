# コントリビューションガイド

このドキュメントでは、stzky-composeリポジトリへのコントリビューション方法について説明します。

## 開発

### YAMLフォーマット

このプロジェクトでは、YAMLファイルのフォーマットに`yamlfmt`を使用しています。このツールは`go.mod`で指定されています:

```bash
go tool yamlfmt
```

変更をコミットする前に、必ずこのコマンドを実行してYAMLファイルをフォーマットしてください。

### テスト

各サービスのComposeファイルは、GitHub Actionsで自動的にテストされます。ローカルでテストする場合は:

```bash
cd <サービスディレクトリ>
docker compose up -d
```

テスト用の設定がある場合:

```bash
docker compose -f compose.yaml -f compose.test.yaml up -d
```

### コミットメッセージ

コミットメッセージは[Conventional Commits](https://www.conventionalcommits.org/)に従ってください。サービス単位で分けられている各ディレクトリの名前（`caddy`、`grafana`、`immich`、`uptime-kuma`など）をスコープとして利用します。

例:
- `feat(grafana): add prometheus configuration`
- `fix(caddy): update reverse proxy settings`
- `chore(immich): update docker image version`
- `docs: add comprehensive Japanese documentation`
