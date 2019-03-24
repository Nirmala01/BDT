# Implementasi MongoDB 
Downloadlah terlebih dahulu MongoDB [disini](https://www.mongodb.com/download-center/community?jmp=docs) dan MongoDB Compass [disini](https://www.mongodb.com/download-center/compass) dan lakukan install seperti biasanya.

Sebelum melakukan implementasi mongodb, lakukan registrasi ke website [mongodb](https://www.mongodb.com/)

setelah login, maka akan ditunjukkan cara membuat cluster ikutilah langkah-langkahnya, setelah selesai akan tampil seperti gambar ini
(ss)

Sekarang buatlah user untuk database yang kita buat di mongodb website > Clusters > Sequrity > MongoDB Users
(ss)

setelah itu setting ip Address di mongodb website > Clusters > Sequrity > IP Whitelist
(ss)

Selanjutnya sambungkan ke cluster dengan klik ```connet``` maka akan tampil sepeti gambar ini 

pilihlah MongoDB Compass karena tadi kita telah mengeinstallnya dan ikutilah langkah-langkah yang ada.

setelah itu buka MongoDB Compass dan sambungkan, maka akan muncul seperti dibawah ini.
[ss]

Selanjutnya lakukan Import file json, pada kali ini saya menggunakan dataset [Iris](https://storage.googleapis.com/kaggle-datasets/20079/26025/iris.json?GoogleAccessId=web-data@kaggle-161607.iam.gserviceaccount.com&Expires=1553685532&Signature=boM5JGwDNLha7lJCFBl433HZOg%2BSufZgC8tV1fjobZSaC8sny0dG%2FwYgKCnBUWP6uhCT5Czx7%2FmKn42UShpfkMibExT6pLEIb0cSaFWpmzm9lL2BVTAA3IILt0J9cwOmVe0aivwyXbfDNcLtM0FerrPDAWFwqSdl22WEZil4X3RwQigxUq5t%2BCnLU1X7Gz77oy9Tdq2JbAjIrSQfSLCUOnxouiXeN8H%2BN7us1Yl4gGbjgOXuerRqZYGxjB3t0UnzsH%2FbzKyT5bA4RXxhpHAs82IZ%2FrEfn75odJZCCOpi8RHBnlObHPLb%2FaKGixZaFjt%2Fc1fIQ%2FXi8m%2BqzEwi8nSbjg%3D%3D) yang diambil dari [Kaggle](https://www.kaggle.com/). menggunakan ```cmd``` dan bukalah file mongodb dan lakukan sintak seperti berikut
```
mongoimport --host clusterdb1-shard-00-00-qlv0u.mongodb.net:27017 --db iris --type json --file D:\iris.json --jsonArray --authenticationDatabase admin --ssl --username kumal --password Kumal4444
```
keterangan :
--host adalah host yang digunakan untuk melakukan import pada kasus ini host diambil dari cluster primary karena kita menggunakan cluster ```clusterdb1-shard-00-00-qlv0u.mongodb.net:27017```.
--db adalah database yang digunakan disini saya menggunakan db iris.
--type type yang digunakan, pada kasus ini saya menggunakan json.
--file lokasi file dari json.
--authenticationDatabase autotentikasi yang digunakan adalah admin.

Jika muncul error seperti gambar dibawah ini maka gantilah jaringan yang kalian gunakan. kemungkinan mongodb mengblokir jaringan anda
[ss]

Setelah berhasil akan muncul seperti gambar dibawah ini maka import dataset json telah berhasil
[ss]

Selanjutnya mengakses data menggunakan MongoDB Compass dan refrest maka akan muncul seperti ini
[ss]

# Regferensi
https://docs.mongodb.com/manual/

https://docs.mongodb.com/manual/crud/



