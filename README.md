# Egrn_microservices
[![Build Status](https://travis-ci.com/otus-devops-2019-02/Egrn_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/Egrn_microservices)
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
