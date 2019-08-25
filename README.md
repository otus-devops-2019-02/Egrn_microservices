[![Build Status](https://travis-ci.com/otus-devops-2019-02/Egrn_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/Egrn_microservices)
# Egrn_microservices

## HW25: kubernetes-1

#### Задачи
- Опишем приложение в контексте Kubernetes с помощью manifest-ов в YAML-формате
- Пройти https://github.com/kelseyhightower/kubernetes-the-hard-way

#### Решение
```
kubectl get pods -o wide
```
NAME                                  READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE
busybox-bd8fb7cbd-vfjw7               1/1     Running   0          38m     10.200.2.2   worker-2   <none>
comment-deployment-58956cb4c9-wlsjb   1/1     Running   0          5m17s   10.200.1.3   worker-1   <none>
mongo-deployment-666c78df77-s7w79     1/1     Running   0          4m52s   10.200.2.4   worker-2   <none>
nginx-dbddb74b8-zd72w                 1/1     Running   0          27m     10.200.2.3   worker-2   <none>
post-deployment-55df476b77-vkn2p      1/1     Running   0          5m9s    10.200.0.4   worker-0   <none>
ui-deployment-584b7bf84f-sx92b        1/1     Running   0          5m3s    10.200.1.4   worker-1   <none>
untrusted                             1/1     Running   0          19m     10.200.0.3   worker-0   <none>

#### Задача *
Описать установку компонентов Kubernetes из THW в виде Ansible-плейбуков

#### Решение *
```
cd kubernetes/the_hard_way/ansible

ansible-playbook playbooks/controller.yml -i make-inventory.sh -l controller

ansible-playbook playbooks/worker.yml -i make-inventory.sh -l worker
```


## HW23: monitoring-3

## HW21: monitoring-2

## HW20: monitoring-1

#### Задачи
Упражнения с prometheus
#### Решение
https://hub.docker.com/u/egrn

#### Задача *
Добавьте в Prometheus мониторинг MongoDB с использованием необходимого экспортера
#### Решение *
```
cd ./monitoring

git clone https://github.com/percona/mongodb_exporter

sed -E 's#.*ENTRYPOINT.*#ENTRYPOINT [ "/bin/mongodb_exporter","--collect.database", "--collect.collection", "--collect.topmetrics", "--collect.indexusage" ]\nENV MONGODB_URI mongodb://r_db:27017#g' -i ./mongodb_exporter/Dockerfile

echo -e "\
  - job_name: 'mongo'
    static_configs:
      - targets:
        - 'mongodb-exporter:9216'
" >> prometheus/prometheus.yml

cd ./mongodb_exporter

make docker
```
Дополнение в ./docker/docker-compose.yml

#### Задача **
Добавьте в Prometheus мониторинг сервисов comment, post, ui с помощью https://github.com/prometheus/blackbox_exporter
#### Решение **
```
cd ./monitoring

echo -e "\
  - job_name: 'blackbox'
    params:
      module: [http_2xx]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - 'localhost:9090'
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115  # The blackbox exporter's real hostname:port.
" >> prometheus/prometheus.yml
```
Дополнение в ./docker/docker-compose.yml

#### Задача **
Напишите Makefile, который в минимальном варианте умеет
- Билдить любой или все образы, которые сейчас используются
- Умеет пушить их в докер хаб
#### Решение **
```
./monitoring/make
```
https://hub.docker.com/u/egrn

___
___
## HW19: gitlab-ci-1
#### Задачи
Gitlab, Runners, Pipeline,...
#### Решение
Done

#### Задача *
В шаг build добавить сборку контейнера с приложением reddit
Деплойте контейнер с reddit на созданный для ветки сервер.
#### Решение *
Использовал docker-in-docker, и публичный registry. Локальный в gitLab не стал поднимать, чтобы избежать настройки ssl для временного хоста.

#### Задача **
Автоматизация развертывания и регистрации Gitlab CI Runner.
#### Решение **
Добавил набросок скрипта в gitlab-ci/make-runners.sh

#### Задача ***
Настройте интеграцию вашего Pipeline с тестовым Slack-чатом
#### Решение ***
https://app.slack.com/client/T6HR0TUP3/CH21S782J/app_profile/BENMSA23E

___
___
## HW17: docker-4
#### Задачи
1) Изменить docker-compose под кейс с множеством сетей, сетевых алиасов (стр 18).
2) Параметризуйте с помощью переменных окружений
3) Использовать файл .env (без команд source и export)
#### Решение
Done
#### Задача
Узнайте как образуется базовое имя проекта
#### Решение
docker-compose -p ownname up -d

#### Задача *
1) Изменять код каждого из приложений, не выполняя сборку образа
2) Запускать puma для руби приложений в дебаг режиме с двумя воркерами (флаги --debug и -w 2)
#### Решение *
```
rsync -avh -e "ssh -i /root/.docker/machine/machines/docker-host/id_rsa" ./ docker-user@35.228.127.163:/home/docker-user/app/
docker-compose -f docker-compose.override.yml -p override up -d
```

___
___

## HW16: docker-3
#### Задачи
Оптимизровать Dockerfile-ы
#### Решение
done
#### Задачи *1
Запустить сеть микросервисов с новыми hostname без изменения образов

#### Решение *1
```
docker run -d --network=reddit --network-alias=r_db mongo:latest \
&& docker run -d --network=reddit --network-alias=r_post --env POST_DATABASE_HOST=r_db egrn/post:1.0 \
&& docker run -d --network=reddit --network-alias=r_comment --env COMMENT_DATABASE_HOST=r_db egrn/comment:1.0 \
&& docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=r_post --env COMMENT_SERVICE_HOST=r_comment egrn/ui:1.0
```
#### Задачи *2
Пересобрать на alpine дистрибутивах

#### Решение *2
```
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
egrn/ui                1.0                 644c0e9187d1        8 minutes ago       276MB
egrn/comment           1.0                 cd4d22755423        13 minutes ago      274MB
egrn/post              1.0                 f0c26fdea6f0        4 hours ago         269MB
mvertes/alpine-mongo   latest              ef364a8cf19c        3 months ago        123MB
```
___
___
## HW15: docker-2

#### Задачи
Сравнить вывод с/без pid host

#### Решение
Без опции выводит изолированное namespase процессов (контейнер). С опцией выводит namespace ВМ GCE, т.е. хостовое пространство.
__

#### Задачи *1
Прототип /docker-monolith/infra/
• Поднятие инстансов с помощью Terraform, их количество задается переменной;
• Несколько плейбуков Ansible с использованием динамического инвентори для установки докера и запуска там образа приложения;
• Шаблон пакера, который делает образ с уже установленным Docker

#### Решение *1
Готово
```
cd ./docker-monolith/infra/terraform
terraform apply -auto-approve
cd ../ansible
ansible-playbook site.yml -i make-inventory.sh
cd ..
packer build -var-file=packer/variables.json packer/db.json
```

___
___

## HW14: docker-1

#### Задачи
Cохранить вывод команды docker images в файл docker-monolith/docker-1.log

#### Решение
Сделано_
__

#### Задачи *1
Сравните вывод двух следующих команд:
>docker inspect <u_container_id>
>docker inspect <u_image_id>

#### Решение *1
Описал в docker-monolith/docker-1.log

___
___
