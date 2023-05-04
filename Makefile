generate-secret:
	@openssl rand -hex 32

install-helm:
	@sudo snap install helm --classic


show-current-commit-hash:
	@STATE=$(git rev-list -1 HEAD); print($STATE)
	