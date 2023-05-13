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

run:
	# docker が更新されない場合 --cache-artifacts=false
	@skaffold dev -p base --default-repo='192.168.0.10:32000' --insecure-registry 192.168.0.10:32000 --kube-context microk8s

delete:
	@skaffold delete -p base --kube-context microk8s

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
