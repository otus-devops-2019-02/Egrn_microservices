docker-machine create \
--driver google \
--google-zone europe-north1-a \
--google-machine-type custom-1-4096 \
--google-disk-size 50 \
--google-disk-type pd-ssd \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
gitlab-docker

docker-machine ls

./make-inventory.sh -l

./make-compose.sh

ansible-playbook docker-host-docker.yml -i make-inventory.sh
