generate-secret:
	@openssl rand -hex 32

install-helm:
	@sudo snap install helm --classic


show-current-commit-hash:
	@STATE=`git rev-list -1 HEAD`;echo $$STATE

show-image:
	@curl http://192.168.0.10:32000/v2/_catalog
	@curl http://192.168.0.10:32000/v2/skaffold-buildpacks-node/tags/list


ska:
	@skaffold dev --default-repo='192.168.0.10:32000'




run-dashboard:
	@microk8s kubectl get services -n kube-system
	@microk8s kubectl -n kube-system describe secret $(microk8s kubectl -n kube-system get secret | grep default-token | awk '{print $1}')
	@microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard --address 0.0.0.0 10443:443


doc-build:
	@docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build

doc-serve:
	@docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
