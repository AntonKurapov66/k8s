# Домашнее задание к занятию «Конфигурация приложений» - Курапов Антон

## Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

* Создать Deployment приложения, состоящего из контейнеров nginx и multitool.
* Решить возникшую проблему с помощью ConfigMap.
* Продемонстрировать, что pod стартовал и оба конейнера работают.
* Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
* Предоставить манифесты, а также скриншоты или вывод необходимых команд.

## Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS

* Создать Deployment приложения, состоящего из Nginx.
* Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
* Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
* Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS.
* Предоставить манифесты, а также скриншоты или вывод необходимых команд.


## Решение 1.

Создадим манифесты configmap8.yaml, deployment8.yaml, service8.yaml : 


```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to Nginx!</title>
    </head>
    <body>
        <h1>Homework8</h1>
        <p>This is a simple Nginx page served from a ConfigMap.</p>
    </body>
    </html>
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: config-volume
          mountPath: /usr/share/nginx/html
      - name: multitool
        image: wbitt/network-multitool
        args: ["tail", "-f", "/dev/null"]
      volumes:
      - name: config-volume
        configMap:
          name: nginx-config
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx-multitool
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
  type: NodePort
```

Если не использовать ConfigMap, то Nginx не найдёт нужные файлы и вернёт ошибку 404. По умолчанию Nginx ищет файлы сайта в /usr/share/nginx/html. Если туда не подложить index.html, он просто покажет страницу ошибки.
Если не монтировать ConfigMap, то Nginx будет использовать файлы, которые есть внутри контейнера по умолчанию.
Если изменить содержимое /usr/share/nginx/html, но без ConfigMap, то придётся пересобирать образ Nginx каждый раз при изменении страницы.


![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_8/jpg/01_0.PNG) 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_8/jpg/01_1.PNG) 

## Решение 2.

Создаем сертификат и добавляем его в серкреты нашего кластера.

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=nginx/O=nginx"
```
```sh
kubectl create secret tls nginx-tls --cert=tls.crt --key=tls.key
```
Подготавливаем манифесты для разворачивания приложения: 

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-https-config
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to Secure Nginx!</title>
    </head>
    <body>
        <h1>HTTPS Works!</h1>
        <p>This page is served securely with SSL.</p>
    </body>
    </html>
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-https
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-https
  template:
    metadata:
      labels:
        app: nginx-https
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        volumeMounts:
        - name: config-volume
          mountPath: /usr/share/nginx/html
        - name: tls-volume
          mountPath: /etc/nginx/ssl
          readOnly: true
      volumes:
      - name: config-volume
        configMap:
          name: nginx-https-config
      - name: tls-volume
        secret:
          secretName: nginx-tls
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-https-service
spec:
  selector:
    app: nginx-https
  ports:
  - protocol: TCP
    port: 443
    targetPort: 80
 # type: ClusterIP
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-https-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - homework8.com
    secretName: nginx-tls
  rules:
  - host: homework8.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-https-service
            port:
              number: 443
```

Разворачиваем все манифесты и на локальной машине прописываем в /etc/hosts следующую строчку: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_8/jpg/02_0.PNG) 

```txt
192.168.56.104 homework8.com
```
где 192.168.56.104 - это IP ноды 

проверяем доступность с помощью curl 

```sh 
curl -k https://homework8.com
```

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_8/jpg/02_1.PNG) 
