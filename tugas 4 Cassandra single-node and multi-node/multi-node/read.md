# Implementasi Cassandra dengan Multi-Node
Pada kasus ini saya menggunakan dua node dengan ip 192.168.33.11 dan 192.168.33.12. untuk membuat multi-node kita perlu install cassandra disetiap node. Instalasi Cassandranya sama dengan langkah-langkah yang digunakan pada pembuatan single-node bisa dilihat [disini](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/single-node/read.md)
##### node 1 yang telah kita install Cassandra
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/node1.PNG)

##### node 2 yang telah kita install Cassandra
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/node2.PNG)

## Menghapus data default
sebelum membuat multi-node. kita harus menghapus data di masing-masing node, sebelumnya kita harus mematikan cassandra terlebih dahulu. ikuti sintaks dibawah ini.
```
sudo service cassandra stop
sudo rm -rf /var/lib/cassandra/data/system/*
```
## Konfigurasi Cassandra yaml
kita perlu mengubah konfigurasi ```cassandra.yaml``` file yang terletak pada direktori ```etc/cassandra.yaml```. ubahlah seperti berikut :
```
.....
cluster_name: 'CassandraCluster' #Nama Cluster anda, harus sama pada masing-masing node
.....
seed_provider:
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
         #ip node 1,ip node 2, dan seterusnya jika ada
         - seeds: "192.168.33.11,192.168.33.12"
.....
listen_address: 192.168.33.11 #ip masing-masing node tempat cassandra berjalan, 192.168.33.11 ini adalah node 1
.....
rpc_address: 192.168.33.11 #ip masing-masing node tempat cassandra berjalan, 192.168.33.11 ini adalah node 1
.....
endpoint_snitch: GossipingPropertyFileSnitch
```
## Jalankan kembali Cassandra
jalankan kembali cassandra dan cek status node dengan sintaks berikut :
```
sudo service cassandra start
sudo nodetool status
```
jika outputnya telah menampilkan kedua node maka multi-node yang telah dibuat berhasil.
contoh pada node 1 :
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/node1statusaktif.PNG)
contoh pada node 2 :
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/node2statusaktif.PNG)

## Apabila node belum terdeteksi
apabila gagal tidak menampilkan tunggulah terlebih dahulu dan jalankan kemabali ```sudo nodetool status``` . jika masih gagal, maka kita perlu memberikan akses node untuk mengakses node lain dengan ```IPTABLES``` dengan sintaks seperti ini :
```
sudo iptables -A INPUT -p tcp -s 192.168.33.12 -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT
#Ganti 192.168.33.12 dengan masing-masing node, syntax ini dijalankan di 192.168.33.11
```
apabila belum memiliki ```IPTABLES``` maka install lah terlebih dahulu dengan sintaks seperti ini:
```
sudo apt-get install iptables -y
```
### Kesimpulan 
sangat mudah dalam proses isntalasi cassandra multi-node dikarenakan cassandra telah didukung oleh arsitektur multi-node secara default berbeda dengan MySQL cluster yang terbilang susah. kita juga dapat mengakses node lain dengan sintaks :
```
cqlsh <ip-node> 9042
```
contohnya sepeti ini. cassandradb1 memiliki ip 192.168.33.11
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/conn.PNG)

### Referensi
https://www.digitalocean.com/community/tutorials/how-to-run-a-multi-node-cluster-database-with-cassandra-on-ubuntu-14-04
