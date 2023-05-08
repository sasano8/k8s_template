sudo apt install nfs-kernel-server
sudo mkdir -p /srv/nfs/kubedata
sudo touch /srv/nfs/README.md

cat << EOF > /etc/exports
/nfs 192.168.1.0/24(rw,no_root_squash)
EOF
