# EAS Basis Data terdistribusi
# Wordpress. RDBMS: MySQL Cluster, NoSQL: Redis cluster (untuk sistem cache)

## Arsitektur
#### Dibawah ini merupakan pembagian Arsitektur IP mysql-cLuster dan IP redis-cluster yang kita gunakan:

No | HostName |    IP    | Keterangan  |
---|----------|----------|-------------|
1  |clusterdb1|192.168.33.11|ndb-Manager dan master redis|
2 |clusterdb2|192.168.33.12|Node 1 dan API 1 dan slave1 redis|
3 |clusterdb3|192.168.33.13|Node 2 dan API 2 dan slave2 redis|
4 |clusterdb4|192.168.33.14|Load Balance(ProxySQL)|

## Implementasi 
#### Buatlah implementasi MySQL Cluster 

- Ikutilah langkah tutorial tugas 1 implementasi mysql cluster [disini](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/tree/master/tugas%20implementasi)

#### Buatlah implementasi Wordpress 

- Ikutilah langkah tutorial tugas ETS untuk membuat wordpress [disini](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/read.md)

#### Buatlah implementasi Redis Cluster

- Ikutilah langkah tutorial tugas implementasi redis [disini](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%205%20Implementasi%20Redis/read.md)

#### Buatlah implementasi Redis Cache pada wordpress

- Pertama kita harus menginstall plugin  ```Redis Object Chace```.

```
Plugins > Add New > Redis Object Cache > Install Now > Activate
```

[ss]

- Kemudian bukalah wp-config.php pada proxy atau clusterdb4 dengan sintaks berikut 
```
sudo nano wp-config.php
```

- Kemudian tambahkan konfigurasi berikut:
```
define( 'WP_REDIS_CLIENT', 'predis' );
define( 'WP_REDIS_SENTINEL', 'mymaster' );
define( 'WP_REDIS_SERVERS', [
    'tcp://192.168.33.11:26379?database=15&alias=master',
    'tcp://192.168.33.12:26379?database=15&alias=slave1',
    'tcp://192.168.33.13:26379?database=15&alias=slave2',
] );

define('WP_CACHE_KEY_SALT', 'example.com'); #WP_CACHE_KEY_SALT mengatur untuk semua key chace
define('WP_CACHE', true);  #WP_CACHE membuat cache persistent dengan plugin redis object chace
```

## Monitoring Redis Cache

#### mengecek koneksi redis 
```
Settings > Redis > Enable Object Cache
```

- sebelum konfigurasi wp-config.php nya 

[ss]

- sesudah konfigurasi wp-config.php nya

[ss]

jadi status redis sudah conncented dengan 3 server yang telah kita konfigurasi pada wp-config.php sebelumnya

- Monitoring dilakukan pada redis master dan slave 1 dan 2 dengan sintaks berikut:
```
redis-cli monitor
```

- lalu cobalah membuat post baru pada wordpress

[ss]


### Referensi
https://www.digitalocean.com/community/tutorials/how-to-configure-redis-caching-to-speed-up-wordpress-on-ubuntu-14-04 https://wordpress.org/plugins/redis-cache/ https://www.cloudways.com/blog/install-redis-cache-wordpress/




