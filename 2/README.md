# Домашнее задание к занятию 2 «Кластеризация и балансировка нагрузки» - Панина Наталия

## Задание 1

    Запустите два simple python сервера на своей виртуальной машине на разных портах
    Установите и настройте HAProxy, воспользуйтесь материалами к лекции по ссылке
    Настройте балансировку Round-robin на 4 уровне.
    На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.
    
## Решение

Создаю две папки с файлами index.html:

    mkdir http1
    mkdir http2
    cd http1
    nano index.html -> Server 1 :8888

Запускаю простой сервер:

    python3 -m http.server 8888 --bind 0.0.0.0

То же делаю для второго сервера в папке http2: nano index.html -> Server 2:9999
    
Проверка работы:

    curl http://localhost:8888
    curl http://localhost:9999

Установка и конфигурация HAproxy:

    sudo apt install haproxy
    sudo nano /etc/haproxy/haproxy.cfg

В файл конфигурации добавляю:

```
listen stats # веб-страница со статистикой 
        bind :888
        mode http 
        stats enable 
        stats uri /stats 
        stats refresh 5s 
        stats realm Haproxy\ Statistics

frontend example # секция фронтенд 
        mode http 
        bind :8088 
        default_backend web_servers

backend web_servers # секция бэкенд 
        mode http
        balance roundrobin 
        option httpchk
        http-check send meth GET uri /index.html 
        server s1 127.0.0.1:8888 check 
        server s2 127.0.0.1:9999 check
```
После сохранения файла конфигурации перегружаю haproxy:

    sudo systemctl reload haproxy
    curl http://127.0.0.1:8088

![HAproxy](https://github.com/nataliya-panina/sflt/blob/main/2/haproxy_round_robin.png)    

Статистика:

    http://127.0.0.1:888/stats
    
![http://127.0.0.1:888/stats](https://github.com/nataliya-panina/sflt/blob/main/2/haproxy_round_robin_stats.png)


## Задание 2

    Запустите три simple python сервера на своей виртуальной машине на разных портах
    Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
    HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
    На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.
    
## Решение

Запускаю третий сервер:

    mkdir http3
    cd http3
    nano index.html -> Server 3:5555
    python3 -m http.server 5555 --bind 0.0.0.0

Изменяю файл конфигурации:
```    
listen stats # веб-страница со статистикой
        bind :888
        mode http
        stats enable
        stats uri /stats
        stats refresh 5s
        stats realm Haproxy\ Statistics

frontend example # секция фронтенд
        mode http
        bind :8088
        #default_backend web_servers
        acl ACL_example.local hdr(host) -i example.local # фильтр по хосту
        use_backend web_servers if ACL_example.local

backend web_servers # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s1 127.0.0.1:8888 check weight 2
        server s2 127.0.0.1:9999 check weight 3
        server s3 127.0.0.1:5555 check weight 4
```
![Layer_7_1](https://github.com/nataliya-panina/sflt/blob/main/2/haproxy_balance_7.png)

![Layer_7_2](https://github.com/nataliya-panina/sflt/blob/main/2/haproxy_layer7.png)


# Задания со звёздочкой*

## Задание 3*

    Настройте связку HAProxy + Nginx как было показано на лекции.
    Настройте Nginx так, чтобы файлы .jpg выдавались самим Nginx (предварительно разместите несколько тестовых картинок в директории /var/www/), а остальные запросы переадресовывались на HAProxy, который в свою очередь переадресовывал их на два Simple Python server.
    На проверку направьте конфигурационные файлы nginx, HAProxy, скриншоты с запросами jpg картинок и других файлов на Simple Python Server, демонстрирующие корректную настройку.

## Задание 4*

    Запустите 4 simple python сервера на разных портах.
    Первые два сервера будут выдавать страницу index.html вашего сайта example1.local (в файле index.html напишите example1.local)
    Вторые два сервера будут выдавать страницу index.html вашего сайта example2.local (в файле index.html напишите example2.local)
    Настройте два бэкенда HAProxy
    Настройте фронтенд HAProxy так, чтобы в зависимости от запрашиваемого сайта example1.local или example2.local запросы перенаправлялись на разные бэкенды HAProxy
    На проверку направьте конфигурационный файл HAProxy, скриншоты, демонстрирующие запросы к разным фронтендам и ответам от разных бэкендов.

