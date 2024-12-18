What is Load Balancer?
=============

![68747470733a2f2f692e696d6775722e636f6d2f4a486b6d3568632e706e67](https://github.com/user-attachments/assets/24259651-c126-4db2-a63a-03d60fff668a)


Containers
=============

- `1 nginx load balancer`
- `3 php-fpm`
- `1 MySQL`
- `1 Memcached`
- `1 Sphinx`
- `1 Prometheus`
- `1 Grafana`
- `1 nginx_exporter`
- `3 php_fpm_exporter`
- `1 mysql_exporter`
- `1 memcached_exporter`
- `1 node-exporter`

Exporters for prometheus only for test purposes you can `delete/disable` it in the files `./_docker/docker-compose.yml` and `./configs/prometheus/prometheus.yml` 


Initial setup:
=============

1. Go to directory with file `docker-compose.yml`:
```
cd _docker
```

2. Start the containers:

```
docker-compose up -d
```

3. Once started, run `setup1.sh` to create the local environment.

```
./setup1.sh
```

4. After `setup1.sh` executed successfully start `setup2.sh`:

```
./setup2.sh
```

At this point, the container should be available at:

- `Site` - <http://localhost:8071> or <https://localhost:8071> 
- `Prometheus` - <http://localhost:9093> or <http://YOUR_SERVER_IP:9093> (Basic Auth: Username: user Password: password)  
- `Grafana` - <http://localhost:9094> or <http://YOUR_SERVER_IP:9094> (Basic Auth: Username: user Password: password)

You can change ports in the `.env` file.

Grafana dashboards of exporters:
=============

- `node-exporter` - <https://grafana.com/grafana/dashboards/1860-node-exporter-full/>
- `nginx_exporter` - <https://grafana.com/grafana/dashboards/10393-nginx/>
- `php_fpm_exporter` - <https://grafana.com/grafana/dashboards/4912-kubernetes-php-fpm/>
- `MySQL` - <https://grafana.com/grafana/dashboards/14969-mysqld-overview/>
- `Memcached` - <https://grafana.com/grafana/dashboards/20480-memcached/>

How to add Prometheus to Grafana?
=============
- Go to <http://localhost:9094/connections/add-new-connection> or <http://YOUR_SERVER_IP:9094/connections/add-new-connection> (Basic Auth: Username: user Password: password)
- tab `Add new connection`. Select `Prometheus`
- click `Add new datasource` 
- Fill `Connection` -> `Prometheus server URL` = <http://prometheus:9090>
- Click `Save and Test`


How to import Grafana dashboards?
=============
- Go to <http://localhost:9094/dashboards> or <http://YOUR_SERVER_IP:9094/dashboards> (Basic Auth: Username: user Password: password)
- click at `Dashboards` tab
- click `New` -> `Import`
- for example we use `node-exporter` - <https://grafana.com/grafana/dashboards/1860-node-exporter-full/>
- download `.json` file of `node-exporter` dashboards from here: <https://grafana.com/grafana/dashboards/1860-node-exporter-full/>
- open `.json` file, copy all context and past it in the textarea `Import via dashboard JSON model`
- click `Load` button 
- select `Prometheus`
- click `Import` button

How to generate `yoursite.com.chained.crt` and  `server.key`?
==========

1. Generate a private key (server.key)
```
openssl genrsa -out server.key 2048
```
2. Generate CSR (Certificate Signing Request)
```
openssl req -new -key server.key -out server.csr
```
When you run the command, you will be prompted to enter the data for the certificate:

- Country Name (2 letter code): RU, US, etc.
- State or Province Name: Your region or state
- Locality Name (e.g., city): City
- Organization Name (e.g., company): Company name
- Organizational Unit Name: Department
- Common Name (e.g., your domain): www.yoursite.com
- Email Address: admin@yoursite.com

3. Generating a self-signed certificate (chained.crt)
```
openssl x509 -req -days 365 -in server.csr -signkey server.key -out www.yoursite.com.chained.crt
```

How to generate .htpasswd ?
==========

Use following `command` :

```
htpasswd -c /var/www/domain.com/public_html/.htpasswd user
```