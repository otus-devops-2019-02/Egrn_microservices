#!/bin/bash

cd ./terraform-runner 
terraform init \
&& terraform apply -auto-approve

../make-inventory.sh -l |
tee ../inventory.json

cd ..

export gitlab_private_token='toVvxhxxi8Dec1i1Vah4'
export gitlab_ci_ip=`cat inventory.json | jq '.service.hosts[]' -cr | tail -1`
export gitlab_runner_ip=`cat inventory.json | jq '.runner.hosts[]' -cr | tail -1`
export gitlab_registration_token=`curl -s --header "PRIVATE-TOKEN: $gitlab_private_token" http://$gitlab_ci_ip/api/v4/projects/1 | jq '.runners_token' -cr`
export gitlab_gcp_project='docker-235620'

#ansible-playbook playbook-runner.yml -i make-inventory.sh

last_runner=`curl -s --header "PRIVATE-TOKEN: $gitlab_private_token" http://$gitlab_ci_ip/api/v4/runners/all | jq '.[].id' -cr | tail -1`
export gitlab_runner_token=`curl -s --header "PRIVATE-TOKEN: $gitlab_private_token" http://$gitlab_ci_ip/api/v4/runners/$last_runner | jq '.token' -cr`

ansible-playbook playbook-runner-config.yml -i make-inventory.sh
