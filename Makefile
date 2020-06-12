create:
	nixops create k8s-config.nix k8s-deploy.nix -d k8s-demo

deploy:
	nixops deploy -d k8s-demo

clean-filesystem:
	nixops ssh-for-each -d k8s-demo -- rm -rf /var/lib/kubernetes/ /var/lib/etcd/ /var/lib/cfssl/ /var/lib/kubelet/
	nixops ssh-for-each -d k8s-demo -- rm -rf /etc/kube-flannel/ /etc/kubernetes/
