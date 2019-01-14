bootstrap:
	cfy install openstack.yaml \
		-b minikube \
		-i server_name=minikube

uninstall:
	cfy uninstall minikube -p ignore_failure=true

output:
	cfy deployment outputs minikube
