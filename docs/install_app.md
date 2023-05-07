
# NATSのインストール

https://docs.nats.io/running-a-nats-service/nats-kubernetes

```
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm install my-nats nats/nats
```


# NATSとは

クラウドネイティブなメッセージキュー。kafkaなどと互換性はない。

- NATS Server: メッセージを多くとも一回送信する。永続化されないため、メッセージが欠ける可能性がある。
- NATS Streaming: メッセージを少なくとも一回送信する。永続化され、サブスクライバーからACKが返ってくるまでメッセージを保持する。タイミングにより、メッセージは複数回されることがある。Streamingは近々サポートを終了する。
- NATS JetStream: Streamingの後継。分散型管理に対応。また、メッセージの重複に対応している。

通知などの簡単なイベント送信ならServer、確実にイベントを伝達したいならJetStreamを使う。

Serverの配信モデルを「at most once」、Streamingの配信モデルを「at least once」、JetStreamの配信モデルを「exactly once」と呼ぶ。


# JetStreamの有効化


`helm install nats nats/nats --values ha.yaml`

``` yaml
nats:
  jetstream:
    enabled: true

    # メモリを超えた場合ファイルストレージを使用する挙動になるらしい
    memStorage:
      enabled: false
      size: 2Gi

    fileStorage:
      enabled: true
      size: 2Gi
      storageDirectory: /data/
    #   storageClassName: gp3
```


永続化ボリュームの使用。


``` yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: nats-js-disk
  annotations:
    volume.beta.kubernetes.io/storage-class: "default"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi


nats:
  image: nats:alpine

  jetstream:
    enabled: true

    fileStorage:
      enabled: true
      storageDirectory: /data/
      existingClaim: nats-js-disk
      claimStorageSize: 3Gi

  resources:
    requests:
      cpu: 1
      memory: 0.5Gi
    limits:
      cpu: 1
      memory: 0.5Gi
```
