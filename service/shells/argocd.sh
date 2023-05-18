#!/bin/sh -e


NS_ARGO=argocd
NS_USER=mlops1

# https://argo-cd.readthedocs.io/en/stable/getting_started/

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64


kubectl create namespace $NS_ARGO
kubectl -n $NS_ARGO apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 認証無し
# kubectl apply -n $NS_ARGO -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml

# サービスを公開する
kubectl -n $NS_ARGO patch svc argocd-server -p '{"spec": {"type": "LoadBalancer"}}'

# 初期パスワードを取得
TMP_SECRET=$(kubectl -n $NS_ARGO get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

TARGET_SERVER=192.168.0.10
TARGET_PORT=$(kubectl -n argocd get service argocd-server -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
echo connect to: $TARGET_SERVER:$TARGET_PORT
argocd login $TARGET_SERVER:$TARGET_PORT --insecure --username admin --password $TMP_SECRET

argocd account update-password

# 初期パスワードを更新したら削除
kubectl -n $NS_ARGO delete secret argocd-initial-admin-secret


# クラスタを登録する（マルチノードはよく分からない）
kubectl config current-context | xargs argocd cluster add --namespace $NS_ARGO


kubectl create namespace $NS_USER
argocd app create guestbook2 --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace $NS_USER


# argcd Project の機能
# 利用できるGitリポジトリの制限
# デプロイ先のクラスター・Namespaceの制限
# 扱うリソースの制限
# default は制限なく操作可能


# infra manager
# datasource manager
# workflow manager
# data-scientist
# ml-engineer
