bootstrap:
	cfy install openstack.yaml \
		-b minikube \
		-i server_name=minikube

uninstall:
	cfy uninstall minikube -p ignore_failure=true

cancel_install:
	cfy exec cancel `cfy exec li -d minikube | grep "started " | cut -d'|' -f2`

output:
	cfy deployment outputs minikube
