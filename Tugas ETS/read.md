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

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/izinuserpadaproxy.PNG)

# instalasi apache2, php dan wordpress
**masuk ke cluserdb4(proxysql) :**
```
vagrant ssh dbcluster4
```
## install apache dan php
```
sudo apt-get update
sudo apt-get install apache2
sudo apt-get install php -y
sudo apt-get install php-mysql
sudo apt-get install -y php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap php-tidy curl
```

## instalasi wordpress
**Download package wordpress**
```
cd /tmp
wget -c http://wordpress.org/latest.tar.gz
```
**setelah itu ekstrak package wordpress**
```
tar -xzvf latest.tar.gz
```
**Menghapus file index.html pada direktori /var/www/html**
```
sudo rm /var/www/html/*
```
**Memindahkan isi package wordpress ke folder html
```
sudo mv wordpress/* /var/www/html
```
**Memberikan akses pada folder /var/www/html**
```
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo service apache2 restart
```

**ubah database ENGINE menjadi NDBCluster**
**copy schema.php ke file vagrant untuk memudahkan dalam mengedit ```ENGIEN=ndbcluster```.**
```
cp /var/www/html/wordpress/wp-admin/includes/schema.php /vagrant
```
**setelah itu buka schema.php yang sudah dicopykan ke file vagrant dan tambahkan ```ENGINE=ndbcluster``` disetiap tabelnya.**

![ssets]()

**copy kembali schema.php ke dalam direktori var/www/html/wordpress/wp-admin/includes/**
```
sudo cp /vagrant/schema.php /var/www/html/wp-admin/includes/
```
**masuk ke direktori html**
```
cd /var/www/html
```
**Copikan isi wp-config-sample.php ke wp-config.php**
```
sudo cp wp-config-sample.php wp-config.php
```
**buka file wp-config.php dan edit seperti gambar dibawah**
```
sudo nano wp-config.php
```
![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/configphp.PNG)

## bukalah wordpress 192.168.33.14 pada browser

**maka akan muncul gambar seperti ini:**

![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/Screenshot%20(49).png)

**ikuti langkah instalasi wordpress jika berhasil maka muncul seperti gambar ini**

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
![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/showtables.PNG)

## Test database wordpress pada cLuster 2 DAN 3
**cek status ndb pada salah satu node**
```
ndb_mgm
show
```
![ssets](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%20ETS/ssets/statusndbsblmdimatikan.PNG)

**matikan salah satu ndbd (yang dimatikan cludterdb2)**
```
sudo systemctl stop ndbd
sudo pkill -f ndbd
```
[ssets]

jadi ketika salah satu ndbd ataupun service node dimatikan, wordpress masih bisa diakses. jika semua node dimatikan maka akan muncul gambar seperti gambar dibawah karena tidak ada data yang dapat diakses.
[ssets]


# Jmeter
jMeter atau Apache JMeter adalah aplikasi open source berbasis Java yang dapat dipergunakan untuk performance test.

## Instal JMeter
Silahkan download terlebih dahulu jmeter [disini]
**Menjalankan jmeter**
- ekstrak hasil download jmeter 
- masuk ke folder bin
- kliklah ```ApacheJMeter.jar```

## Test Plan Jmeter
**Menambahkan user visitor**
```
klik kanan test plan
Add > Thread (Users) > Thread Group
```
isilah seperti gambar dibawah:
[ssets]

– Number of threads (users) : isi berapa user/visitor yang akan mengakses web.

– Ramp-Up period (in seconds) : isi berapa waktu delay antara user satu dengan yang lainnya dalam mengakses web.

– Loop Count : waktu eksekusi, bertahap atau berulang.
**Menambahkan web server/IP Address yang akan di tes**
```
klik kanan Thread Group
Add > Config Element > HTTP Request Defaults
```
dan isilah sesuai dengan server ip yang akan kalian tes
[ssets]

**tambakan Http Request jika yang akan kita tes tidak hanya halaman utama**
```
Klik kanan Threads Group
Add > Sampler > HTTP Request
```
[ssets]
**Menampilkan proses dan hasil tes secara grafis dan bentuk tabel**
```
Klik kanan Test Plan
Add > Listener > Graph Result
```
[ssets]
```
Klik kanan Test Plan
Add > Listener > View Results in Table
```
[ssets]

```
Klik kanan Test Plan
Add > Listener > Summary Report
```
**Jalankan Jmeter**
klik run atau Ctrl + R

## referensi 






