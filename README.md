# プロジェクト

# スケジュール管理

- https://docs.google.com/spreadsheets/d/1Gu34gPMD5ZblKiCFWaUHLTEDYye_bWVtWNhvxccSEW8

# 構築手順

- [参照](docs/install.md)


# 背景

ML Ops実現のために作られたKubernetes上で動作するPassサービスです。
ML Opsの文脈で使用される一般的なミドルウェア等をKubernets上に簡単にブートストラップします。

- 統合された認証・認可
- データベースやストレージやストリームなど永続層の配置
- 動的サービスの配置
- ジョブのスケジューリング
- ワークフローの整理
- スケーラブル

柔軟な構成に対応し、プロトタイプ開発やそのまま本番環境として使用することも可能です。

# 概要

- Internal Dashboard: 組織内部の管理者やエンジニアが使用するダッシュボードです。アクセス制御等を行い、External Dashboard をカスタマイズします。
- External Dashboard: 外部向けにサービスを提供する場合のダッシュボード。上物を変えることで、ユーザー独自のサイトにカスタマイズできたりするとよい。

# 設計

- postgres 拡張: supabase はpostgresをターゲットにしており、それを参考にする。
- jupyter: kubeflow はjupyterサーバを簡単に起動する仕組みがある。

# セキュリティ

- データを外部送信されたりすると困る
    - ネットワーク制限を行う
    - ネットワーク機能を使用せず、パイプラインでデータを連携する

ここらへん参考になるかも。

https://charmed-kubeflow.io/docs/get-started-with-charmed-kubeflow#heading--part-i-access-charmed-kubeflow


# awasomes

- https://github.com/opendatadiscovery/awesome-data-catalogs
