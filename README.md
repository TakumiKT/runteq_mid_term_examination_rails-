# README

## プロジェクトのセットアップ手順
Dockerを使った環境準備(イメージのビルド)からDockerコンテナの終了までを行った後再度
railsサーバーの起動(バックグラウンドでのコンテナの立ち上げとrailsサーバーの起動)を行ってください

### Dockerを使った環境準備(イメージのビルド)

```
docker compose build
```

### railsサーバーの起動(バックグラウンドでのコンテナの立ち上げとrailsサーバーの起動)

```
docker compose up
*docker compose upを実行しているターミナルとは別に新しくターミナルを立ち上げてください。新しいターミナルにて以下のコマンドを実行してください。
```

### コンテナ内に入る(rails・bundler・yarn関係のコマンドはコンテナ内で実行します)

```
docker compose exec web bash
```

### Gemのインストール

```bash
bundle install
```

### node_modulesのインストール

```bash
yarn install
```

### データベースの作成(コンテナ内で実行してください)

```bash
bin/rails db:setup
```

### JS用のサーバー起動(コンテナ内で実行してください・ターミナルで複数のタブを開くとやりやすいでしょう)

```
yarn build --watch
```

### Dockerコンテナの終了

```bash
docker compose down
```

## テスト

```
$ bundle exec rspec
```

## Lintチェック

```
$ bundle exec rubocop
```

## 課題提出方法
- プルリクエストを作成し、カリキュラムからレビュー依頼を行ってください


