# Домашнее задание к занятию 1 «Disaster recovery и Keepalived» - Панина Наталия
## Задание 1

    Дана схема для Cisco Packet Tracer, рассматриваемая в лекции.
    На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
    Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
    Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
    На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.
## Решение
    Router1>en
    Router1#sh standby brief
    Router1#conf t
    Router1(config)#int g0/1
    Router1(config-if)#standby 1 ip 192.168.1.1 
    Router1(config-if)#standby prio
    Router1(config-if)#standby preempt
    Router1(config-if)#standby 1 track g0/1

![Router1](https://github.com/nataliya-panina/sflt/blob/main/1/Standby1.png)

    Router0#en
    Router0#conf t
    Router0(config)#int g0/1
    Router0(config-if)# standby version 2
    Router0(config-if)# standby 1 ip 192.168.1.1
    Router0(config-if)# standby 1 priority 50
    Router0(config-if)# do sh standby brief
![Router2](https://github.com/nataliya-panina/sflt/blob/main/1/Standby2.png)

![.pkt](https://github.com/nataliya-panina/sflt/blob/main/1/hsrp_advanced.pkt)


## Задание 2

    Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного файла.
    Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
    Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
    Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
    На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html
## Решение

![script.sh](https://github.com/nataliya-panina/sflt/blob/main/1/script.sh)

![keepalived.cfg](https://github.com/nataliya-panina/sflt/blob/main/1/keepalived.cfg)  

Отработка скрипта после переименования файла index.html:  

![Exit1](https://github.com/nataliya-panina/sflt/blob/main/1/exit1.png)  

И обратно:

![Master_status](https://github.com/nataliya-panina/sflt/blob/main/1/Master.png) 

Переход BACKUP в MASTER и обратно:

![Backup_status](https://github.com/nataliya-panina/sflt/blob/main/1/Backup.png)  


**Дополнительные задания со звёздочкой**

Эти задания дополнительные. Их можно не выполнять. На зачёт это не повлияет. Вы можете их выполнить, если хотите глубже разобраться в материале.
## Задание 3*

    Изучите дополнительно возможность Keepalived, которая называется vrrp_track_file
    Напишите bash-скрипт, который будет менять приоритет внутри файла в зависимости от нагрузки на виртуальную машину (можно разместить данный скрипт в cron и запускать каждую минуту). Рассчитывать приоритет можно, например, на основании Load average.
    Настройте Keepalived на отслеживание данного файла.
    Нагрузите одну из виртуальных машин, которая находится в состоянии MASTER и имеет активный виртуальный IP и проверьте, чтобы через некоторое время она перешла в состояние SLAVE из-за высокой нагрузки и виртуальный IP переехал на другой, менее нагруженный сервер.
    Попробуйте выполнить настройку keepalived на третьем сервере и скорректировать при необходимости формулу так, чтобы плавающий ip адрес всегда был прикреплен к серверу, имеющему наименьшую нагрузку.
    На проверку отправьте получившийся bash-скрипт и конфигурационный файл keepalived, а также скриншоты логов keepalived с серверов при разных нагрузках
## Решение

