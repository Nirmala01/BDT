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

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20UAS/ss/Screenshot%20(73).png)

- Cek Koneksi Redis
```
Settings > Redis > Enable Object Cache
```

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20UAS/ss/Screenshot%20(75).png)

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

#### Mengecek koneksi redis
```
Settings > Redis > Enable Object Cache
```

- sesudah konfigurasi wp-config.php. jadi status redis sudah conncented dengan 3 server yang telah kita konfigurasi sebelumnya akan tampil seperti gambar dibawah ini

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20UAS/ss/Screenshot%20(76).png)

- Monitoring dilakukan pada redis master dan slave 1 dan 2 dengan sintaks berikut:
```
redis-cli monitor
```

#### CRUD pada wordpress

- lalu cobalah membuat post baru pada wordpress

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20UAS/ss/Screenshot%20(77).png)

- coba buka post yang sudah ada atau yang telah kita buat

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20UAS/ss/Screenshot%20(78).png)

- lakukan update data post yang telah kita buat

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20UAS/ss/Screenshot%20(80).png)

- Setelah itu coba delete post yang sudah ada

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20UAS/ss/Screenshot%20(79).png)

### Referensi
https://www.digitalocean.com/community/tutorials/how-to-configure-redis-caching-to-speed-up-wordpress-on-ubuntu-14-04 

https://wordpress.org/plugins/redis-cache/  

https://www.cloudways.com/blog/install-redis-cache-wordpress/




