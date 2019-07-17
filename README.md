[![Build Status](https://travis-ci.com/otus-devops-2019-02/Egrn_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/Egrn_microservices)
# Egrn_microservices
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
