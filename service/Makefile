
run:
	@skaffold dev -p base --default-repo='192.168.0.10:32000' --insecure-registry 192.168.0.10:32000 --kube-context microk8s

delete:
	@skaffold delete -p base --kube-context microk8s


@tunnel
	@kubectl port-forward -n kube-system service/kubernetes-dashboard --address 0.0.0.0 10443:443

	# kubectl port-forward service/app-python 8080:3000
	# kubectl port-forward service/app-go 8080:3000