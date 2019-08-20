#!/bin/bash

cd ./terraform-service
terraform init \
&& terraform apply -auto-approve

../make-inventory.sh -l |
tee ../inventory.json

../make-compose-service.sh |
tee ../docker-compose.yml

cd ..
ansible-playbook playbook-service.yml -i make-inventory.sh

