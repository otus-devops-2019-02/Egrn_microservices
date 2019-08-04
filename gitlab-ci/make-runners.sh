# Пердполагая автоматизацию, использовал бы скрипт. Его основы ниже.

docker-machine ls
NAME            ACTIVE   DRIVER   STATE     URL                       SWARM   DOCKER     ERRORS
gitlab-docker   *        google   Running   tcp://35.228.37.96:2376           v19.03.1


eval $(docker-machine env gitlab-docker)


docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest


docker exec -it gitlab-runner gitlab-runner list
Listing configured runners                          ConfigFile=/etc/gitlab-runner/config.toml
RunnerShell                                         Executor=shell Token=8TWGfKWurDMP6GBbwWkw URL=http://35.228.37.96/
Docker Runner                                       Executor=docker Token=1DThjFA2zjeYt9xh1FrQ URL=http://35.228.37.96/



docker exec -it gitlab-runner \
  gitlab-runner register \
  --locked=false \
  --url http://35.228.37.96/ \
  --registration-token 71gYxhT8nL9JGp425zBb \
  --executor shell \
  --description "Shell Runner" \
  --tag-list linux,shell


docker exec -it gitlab-runner \
  gitlab-runner register -n \
  --url http://35.228.37.96/ \
  --registration-token 71gYxhT8nL9JGp425zBb \
  --executor docker \
  --description "Docker Runner" \
  --docker-image "docker:stable" \
  --docker-privileged \
  --tag-list linux,docker
