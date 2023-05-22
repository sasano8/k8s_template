
# 要求スペック

- memory: 1GB + α


# DNS構築

## nip.io

nip.ioは、だれでも使用できる wildcard DNS サービスです。

http://<target_ip>.nip.io

とした時、target_ipにdomainを解決します。




# 構築対象ホストの環境構築

```
sudo apt -y update
sudo apt -y install openssh-server
```

# 管理サーバと構築対象ホストの疎通


```
ssh-keygen
```

```
chmod 0600 ~/.ssh/id_rsa
```

```
Host host1
        HostName        <hostname or ip>
        User            username
        IdentityFile    ~/.ssh/id_rsa
```

```
ssh-copy-id <user>@host
```


# micro k8s のインストール


対象ホストにログインする。

```
ssh host1
```

スペックを確認する。

```
lsb_release -a  # OS
uname -a  # kernel
free -h  # memory
sudo lshw -class processor  # CPU
lspci | grep -i nvidia  # GPU
```

microk8s をインストールする。

https://microk8s.io/docs/getting-started

```
sudo snap install microk8s --classic --channel=1.27

sudo usermod -aG microk8s $USER
mkdir ~/.kube
sudo chown -f -R $USER ~/.kube  # 強制的に再帰的に所有権を変更する
```

グループを有効化するために再ログインする。

```
su - $USER
```

microk8s がセットアップされることを待つ。

```
microk8s status --wait-ready
```

エイリアスを設定する。

```
echo alias kubectl=\'microk8s kubectl\' >> ~/.bash_aliases
```

それか、

```
#!/bin/sh
exec microk8s kubectl "$@"
```


疎通確認をする。

```
microk8s kubectl get nodes
microk8s kubectl get services

# または
kubectl get nodes
kubectl get services
```

標準的なアドオンを追加する。

```
microk8s enable dns
microk8s enable hostpath-storage
microk8s enable registry
```

使用できるアドインやステータスは次で確認できる。

```
microk8s status
```

サンプルアプリケーションをデプロイする。

なお、ポッドはkubernetesにおけるリソースの最小単位で、
デプロイメントはポッドを制御し、期待される状態（インスタンスの数など）を維持しようと働きます。

```
kubectl create deployment nginx --image=nginx

kubectl wait --for=condition=available --timeout=300s deployment/nginx \
&& microk8s kubectl get pods
```

サービスを作成し、払い出されたサービスポートに対して疎通確認を行う。

```
kubectl expose deployment nginx --type=NodePort --port=80
kubectl get services

curl localhost:30317
```

デプロイメントとサービスを削除する。

```
kubectl delete deployment nginx
kubectl delete service nginx
```


クラスタの起動と停止は次のようにコントロールできます。
start状態だと、OSの再起動時などクラスタは自動で起動します。

```
microk8s stop
microk8s start
```


helm(Package manager for Kubernetes)をインストールする。

```
sudo snap install helm --classic
```


skaffold をインストールする。

- https://skaffold.dev/docs/install/

```
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
sudo install skaffold /usr/local/bin/
```

必要ならコンテナイメージレジストリを設定する。
リモートのクラスタを使用する場合は、イメージレジストリを設定する必要がある。

```
skaffold config set default-repo http://192.168.0.10:32000
```



# kubeconfigを使用したkubernetesへのリモートアクセス

kubectlはデフォルトでconfigを参照する。
デフォルトを参照したくない場合は、`KUBECONFIG`環境変数か`--kubeconfig`フラグで変更することができる。

```
scp -r host1:~/.kube .
cp -r .kube $HOME/
ssh host1 microk8s config > ~/.kube/config
```

```
kubectl config get-clusters
```

```
microk8s enable dashboard
microk8s enable rbac


microk8s kubectl get services -n kube-system
microk8s kubectl -n kube-system describe secret $(microk8s kubectl -n kube-system get secret | grep default-token | awk '{print $1}')
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard --address 192.168.0.0 10443:443
```


`local-cluster: true`だと、レジストリにpushしないのでremote k8s環境では上手く動かないかも。

```
# ~/.skaffold/config
global:
  default-repo: 192.168.0.10:32000
  local-cluster: false
  insecure-registries:
    - 192.168.0.10
```


```
vi /var/snap/microk8s/current/args/containerd-template.toml
```

```
sudo microk8s stop && sudo microk8s start
```


skaffold dev -v=debug



# コンテナをデバッグする

コンテナ環境には何も開発ツールが入っていないことがある。
その場合は、busyboxというunixコマンド群を一つのバイナリに含んだツールを使うと良い。

```
kubectl cp /usr/bin/busybox web-57d59dd6fb-9zrfl:busybox

./busybox ls
```

# トラブルシューティング

- https://microk8s.io/docs/registry-private  # hosts.tomlが重要！！！


# キモ

## 環境ごとに設定を変える場合

- Kustomize

```
# kubectl kustomize development | kubectl apply -f -

├── base
│   └── deployment.yaml
├── development
│   ├── dev-patch.yaml
│   └── kustomization.yaml
└── production
    ├── kustomization.yaml
    └── prod-patch.yaml
```

- Helm Chart


プロジェクトディレクトリ？でkustomize をインストール

```
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin/kustomize
```
