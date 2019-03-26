# TUGAS ETS 
## Dibawah ini merupakan pembagian Arsitektur dan IP mysql-cLuster yang kita gunakan:

No | HostName |    IP    | Keterangan  |
---|----------|----------|-------------|
1  |clusterdb1|192.168.33.11|ndb-Manager|
2 |clusterdb2|192.168.33.12|Node 1 dan API 1|
3 |clusterdb3|192.168.33.13|Node 2 dan API 2|
4 |clusterdb4|192.168.33.14|Load Balance(ProxySQL)|

liat disini jika belum membuat [mysql-cluster](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/tree/master/tugas%20implementasi)

# Membuat user dan database wordpress
**masuk ke clusterdb2**
```
vagrant ssh clusterdb2
mysql -u root -p
```
**create user**

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/user%20baru%20wordpress.PNG)

**masuk ke clusterdb4 untuk menambahkan user**
```
vagrant ssh clusterdb4
mysql -u admin -p -h 127.0.0.1 -P 6032 --prompt='ProxySQLAdmin> '
```

![ssets](mysql -u admin -p -h 127.0.0.1 -P 6032 --prompt='ProxySQLAdmin> ')

# instalasi apache2, php dan wordpress
**masuk ke cluserdb4(proxysql) :**
```
vagrant ssh dbcluster4
```
## install apache dan php
```
sudo apt-get install apache2
sudo apt-get install php -y
sudo apt-get install php-mysql
sudo apt-get install -y php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap php-tidy curl
```

## instalasi wordpress
**buat direktori baru didalam direktori  /var/www/html/**
```
mkdir wordpress
```
**masuk ke dalam direktori baru dan install wordpress**
```
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
```

**ubah database ENGINE menjadi NDB**

**copy schema.php ke file vagrant untuk memudahkan dalam mengedit ```ENGIEN=NDB```.**
```
cp /var/www/html/wordpress/wp-admin/includes/schema.php /vagrant
```
**setelah itu buka schema.php yang sudah dicopykan ke file vagrant dan tambahkan ```ENGINE=NDB``` disetiap tabelnya.**

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/engine%3Dndb.PNG)

**copy kembali schema.php ke dalam direktori var/www/html/wordpress/wp-admin/includes/**

**editlah wp-config-sample.php isi sesuai dengan database dan user yang telah kita buat**
```
sudo nano wp-config-sample.php
```
![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/configphp.PNG)

**rename file file wp-config-sample.php menjadi wp-config.php**
```
mv wp-config-sample.php wp-config.php
```
## bukalah wordpress 192.168.33.14/wordpress/wordpress pada browser**

**maka akan muncul gambar seperti ini:**

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/Screenshot%20(49).png)

**ikuti langkah instalasi wordpress jika berhasil maka muncil seperti gambar ini**

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/Screenshot%20(50).png)

**tamilan awal wordpress**

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/Screenshot%20(51).png)

**coba post baru**

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/Screenshot%20(53).png)

**mengecek apakah database sudah terhubung oleh wordpress pada salah satu node**
```
vagrant ssh clusterdb2
mysql -u userwordpress -p -h 192.168.33.14 -P 6033
show databases;
use tugasETS;
```
## Test database wordpress pada cLuster 2 DAN 3
**cek status ndb pada salah satu node**
```
ndb_mgm
show
```
![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/statusndbsblmdimatikan.PNG)

**matikan salah satu node (yang dimatikan cludterdb2)**
```
sudo systemctl stop mysql
```

**node 2 telah dimatikan**
(screenshoot)

**matikan kedua node**
(screenshot)

# Jmeter



