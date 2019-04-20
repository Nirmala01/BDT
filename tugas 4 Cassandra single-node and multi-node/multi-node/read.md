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

## Import Dataset .CSV
##### 1. Masuklah ke cassandra terlebih dahulu dengan ```cqlsh``` . dalam kasus ini saya multi-node maka sintaknya seperti berikut :
```
cqlsh 192.168.33.12
```
sintaks ini saya jalankan di node1 dengan ip yang digunakan ip dari node2 192.168.33.12.
akan terlihat seperti gambar dibawah

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/masukcqlsh.PNG)

##### 2. Buatlah KeySpace karena pada Cassandra database berarti keyspace. dengan sintak sebagai berikut:
```
CREATE KEYSPACE IF NOT EXISTS pokemondb WITH REPLICATION = { 'class' : 'Ne
tworkTopologyStrategy', 'dc1' : 2 };
```
Ganti ```pokemon``` atau keyspace sesuai dengan database yang kalian inginkan. replikasi yang kita gunakan adalah NetworkTopologyStaregy dengan replication factor 2.

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/keyspace2.PNG)

##### 3. Buatlah Table yang isinya sama dengan dataset yang mau kita import. sintaknya sebagai barikut;
```
CREATE TABLE pokemondb.pokemon ( no_id int PRIMARY KEY, Name text, Type_1 text, Type_2 text, Total int
, HP int, Attack int, Defence int, Sp_Atk int, Sp_Def int, Speed int, Generation int, Legendary text );
```
pokemondb adalah keyspace dan pokemon adalah nama table yang kita buat. ```[namadatabe/keyspace].[nama_table]([nama_kolom] [type])```
. ini bisa dijalankan didalam keyspace dengan sintaks ```use [namakeyspace]``` maupun diluar keyspace selama masih didalam cqlsh.

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/buattable.PNG)

##### 4. Import dataset ke Cassandra kedalam table yang telah kita buat sintaksnya sebagai berikut :
sebelum itu masuk ke keyspace
```
use pokemondb
```
lakukan sintaks berikut dan jalan lupa datasetnya pindahkan dalam folder yang sama dengan cassandra multi-node:
```
COPY pokemondb.pokemon (no_id, Name, Type_1, Type_2, Total, HP, Attack, Defence, Sp_Atk, Sp_Def, Speed
, Generation, Legendary) from '/vagrant/Pokemon.csv' WITH DELIMITER=',' AND HEADER=TRUE;
```
hampir sama dengan cara membuat table, seperti ini [namadb].[nama_table]([kolom]) from [dataset.csv] with [value_yangditambahkan].

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/importdb.PNG)

## CDRU

##### 1. Cek hasil Import atau read table 
```
SELECT * FROM pokemondb.pokemon;
```
jika berhasil maka akan tampil data seperti berikut:
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/show%20table.PNG)

##### 2. Create atau membuat data baru 
```
INSERT INTO pokemondb.pokemon ( no_id, Name, Type_1, Type_2, Total, HP, Attack, Defence, Sp_Atk, Sp_Def, Speed, Generation, Legendary) VALUES(1111, 'O
nix red', 'Water', 'Flying', 100, 100, 200, 50, 50, 50, 100, 2, 'False');
```
lalu ```select * from pokemondb.pokemon where no_id=1111;``` maka akan tampil seperti ini.

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/insertdancek.PNG)

##### 3. Update data biar lebih muda saya hanya mengupdate data yang telah kita buat
disini yang mau saya update itu data dari type_1 = Dragon.
```
update pokemondb.pokemon set type_1 = 'Dragon' where no_id=1111;
```
lalu ```select * from pokemondb.pokemon where no_id=1111;``` maka awalnya type_1 = Water berubah menjadi Dragon seperti gambar ini

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/updatedancek.PNG)

##### 4. Delete data 
saya akan menghapus data yang telah kita buat tadi dengan no_id = 1111 dengan sintaks seperti ini
```
delete from pokemondb.pokemon where no_id=1111;
```
lalu cari lagi data dengan no_id = 1111 ```select * from pokemondb.pokemon where no_id=1111;``` maka tidak terdapat data dengan no_id tersebut. seperti gamabr ini:

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/deletedancek.PNG)


### Kesimpulan 
sangat mudah dalam proses isntalasi cassandra multi-node dikarenakan cassandra telah didukung oleh arsitektur multi-node secara default berbeda dengan MySQL cluster yang terbilang susah. kita juga dapat mengakses node lain dengan sintaks :
```
cqlsh <ip-node> 9042
```
contohnya sepeti ini. cassandradb1 memiliki ip 192.168.33.11
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/multi-node/ss/conn.PNG)

### Referensi
https://www.digitalocean.com/community/tutorials/how-to-run-a-multi-node-cluster-database-with-cassandra-on-ubuntu-14-04
