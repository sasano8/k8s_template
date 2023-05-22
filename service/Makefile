MY_VAL := MYAPP

show-val:
	@echo $(MY_VAL)

build-base:
	@kustomize build envs/base

build-dev:
	@kustomize build envs/dev

build-prod:
	@kustomize build envs/prod

run-dry:
	@kustomize build envs/base > generated/base.yaml
	@kustomize build envs/dev > generated/dev.yaml
	@kustomize build envs/prod > generated/prod.yaml

dev:
	# docker が更新されない場合 --cache-artifacts=false
	# default-repoを指定するとイメージに自動で付与してくれるらしい
	@skaffold dev -p base --default-repo='192.168.0.10:32000' --insecure-registry 192.168.0.10:32000 --kube-context microk8s


# skaffold$ skaffold render \
#   -p production \
#   --default-repo xxx.dkr.ecr.ap-northeast-1.amazonaws.com \
#   --offline=true \
#   --loud=true \
#   --output manifest.yaml

delete:
	@skaffold delete -p base --kube-context microk8s

debug:
	@kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- sh

gen:
	@helm template nats nats/nats --values helms/nats_ha.yaml > envs/base/nats-jet-stream.yaml  # skaffold と組み合わせると上手く動かない？

show-volumes:
	@echo "Persistent Volumes"
	@kubectl get pv -A
	@echo "Persistent Volumes Claims"
	@kubectl get pvc -A

tunnel:
	@kubectl port-forward -n kube-system service/kubernetes-dashboard --address 0.0.0.0 10443:443
	# kubectl port-forward service/app-python 8080:3000
	# kubectl port-forward service/app-go 8080:3000


# kustomize適用結果を標準出力に表示
show-kustomize:
	@kubectl kustomize envs/base


# https://argo-cd.readthedocs.io/en/stable/getting_started/
install-argocd:
	@kubectl create namespace argocd
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'  # サービスを公開する場合
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo  # デフォルトパスワード確認
	@kubectl create -n argocd secret tls argocd-server-tls \
		--cert=/path/to/cert.pem \
  		--key=/path/to/key.pem


docker-upload:
	# giteaにはdocker registryが付属している。
	@curl --user username:password http://192.168.0.10:32758/api/packages/testuser/generic/test_package/1.0.0/file.bin

gen-secret:
	@openssl rand -hex 32

# sudo apt install sysstat
stat:
	@mpstat 1 1  # idle が多いほど負荷が少ない
	@free -m  # available が空き容量
