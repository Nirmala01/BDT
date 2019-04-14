
# Implementasi Cassandra Single-Node
Pertama saya hanya membuat satu node dengan IP 192.168.33.10. isi dari Vagrantfile nya seperti ini 
```
Vagrant.configure("2") do |config|
  config.vm.define "cassandra" do |cassandra|
    cassandra.vm.hostname = "cassandra"
    cassandra.vm.box = "ubuntu/xenial64"
    cassandra.vm.network "private_network", ip: "192.168.33.10"
      
    cassandra.vm.provider "virtualbox" do |vb|
      vb.name = "cassandra"
      vb.gui = false
      vb.memory = "1024"
    end

    # cassandra.vm.provision "shell", path: "provision/bootstrap.sh", privileged: false
  end
end
```

## Install Java Virtual Machine
Karena Cassandra membutuhkan java virtual mechine jadi kita perlu menginstall Java. sebelum itu diperlukan beberapa packegae agar dapat membuat reository. 
##### 1. install proprerties-common untuk dapat menambahkan add repository, dengan sintaks :
```
# apt-get update digunakan untuk mengupdate package yang sudah ada
sudo apt-get update
# install lib for add apt 
sudo apt-get install software-properties-common
```
###### 2. Menambahkan repository baru untuk java.
```
# add repository java
sudo add-apt-repository ppa:webupd8team/java
# apt-get update untuk repository java yang baru agar repository yang baru ikut terupdate
sudo apt-get update
```
akan muncul seperti gambar ini jika kita berhasil menambahkan repository baru

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/single-node/ss/addrepositori.PNG)

###### 3. Install java.
```
sudo apt-get install oracle-java8-set-default
```
setelah selesai install java untuk mengecek versi java, ketikkan sintaks berikut :
```
java -version
```
maka akan keluar output seperti ini

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/single-node/ss/versijava.PNG)

## Install Cassandra
Sebelum instalasi cassandra diperlukan export beberapa package serta menambahkan repository key, langkah yang dilakukan adalah
###### 1. kita harus intall cassandra repository ke /etc/apt/sources.list.d/cassandra.sources.list 
```
echo "deb http://www.apache.org/dist/cassandra/debian 39x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
```
###### 2. jalankan cURL command berikut untuk menambahkan repository keys lalu update repository.
```
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
# update repository
sudo apt-get update
```
###### 3. install Cassandra
```
sudo apt-get install cassandra
```
setelah itu lakukan verfikasi intalasi cassandra dengan sintaks. output akan menampilkan **UN** yang artinya semuanya berjalan dengan normal.  
```
nodetool status
```
![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/single-node/ss/nodetoolstatus.PNG)

mengecek status running cassandra denan sintaks :
```
sudo service cassandra status
```
maka akan muncul status cassandra seperti ini

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/single-node/ss/statuscassandra.PNG)

###### 4. melakukan connect dengan cqlsh
```
cqlsh
```
maka akan tampil seperti ini

![ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/tugas%204%20Cassandra%20single-node%20and%20multi-node/single-node/ss/connect.PNG)

### Referensi

https://www.digitalocean.com/community/tutorials/how-to-install-cassandra-and-run-a-single-node-cluster-on-ubuntu-14-04
https://www.liquidweb.com/kb/install-cassandra-ubuntu-16-04-lts/







