
masuk ke proxysql :
```
vagrant ssh dbcluster4
```

# instalasi apache2 dan php
```
sudo apt-get install apache2
 sudo apt-get install php -y
 sudo apt-get install php-mysql
 sudo apt-get install -y php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap php-tidy curl
```

# instalasi wordpress
**buat direktori baru didalam direktori  /var/www/html/ 
```
mkdir wordpress
```
**masuk ke dalam direktori baru dan install wordpress**
```
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
```
**copy schema.php ke file vagrant untuk memudahkan dalam mengedit ```ENGIEN=NDB```
```
cp /var/www/html/wordpress/wp-admin/includes/schema.php /vagrant
```
**setelah itu buka schema.php yang sudah dicopykan ke file vagrant dan tambahkan ```ENGINE=NDB``` disetiap tabelnya.
**copy kembali schema.php ke dalam direktori var/www/html/wordpress/wp-admin/includes/**
**editlah wp-config-sample.php isi sesuai dengan database dan user yang telah kita buat**
```
sudo nano wp-config-sample.php
```
(screenshot wp-config)
**rename file file wp-config-sample.php menjadi wp-config.php
```
mv wp-config-sample.php wp-config.php
```
**bukalah wordpress 192.168.33.14/wordpress/wordpress pada browser**

**maka akan muncul gambar seperti ini:**
(screenshot)

**ikuti langkah instalasi wordpress
(screenshot)

**mengecek apakah database sudah terhubung oleh wordpress 
shema yang telah dibuat pada wordpress, otomatis akan ada didalam node 2, dan node 3
```
vagrant ssh clusterdb2
mysql -u userwordpress -p -h 192.168.33.14 -P 6033
show databases;
use tugasETS;
```
# TEST DATABASE WORDPRESS PADA CLuster 2 DAN 3
cek status ndb pada salah satu node
```
ndb_mgm
show
```
(screenshot)

**matikan salah satu node cluster3
```
sudo systemctl stop mysql
```

**node 2 telah dimatikan
(screenshoot)

matikan kedua node
$ sudo systemctl stop mysql
(screenshot)

# Jmeter



