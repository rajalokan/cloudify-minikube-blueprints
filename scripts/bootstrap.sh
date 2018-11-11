#! /bin/bash -e

ctx logger info "Bootstrapping Minikube"
ctx logger info "Server name is : ${server_name}"
# sudo hostname ${SERVER_NAME}
# grep -q ${SERVER_NAME} /etc/hosts || sudo sed -i "2i127.0.1.1  ${SERVER_NAME}" /etc/hosts
