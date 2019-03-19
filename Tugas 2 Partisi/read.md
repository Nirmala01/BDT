# Partisi
Partisi adalah memecah tabel ke dalam beberapa segment (partisi atau subpartisi), di mana tabel konvensional hanya mempunyai satu segment.
# Tipe Partisi
1. Range
Data dikelompokkan berdasarkan range(rentang) nilai yang kita tentukan. Range partition ini cocok digunakan pada kolom yang nilainya terdistribusi secara merata. Contoh yang paling sering adalah kolom tanggal.
2. List
Pada list partition, data dikelompokkan berdasarkan nilainya. Cocok untuk kolom yang variasi nilainya tidak banyak.
3. Hash
Jika kita ingin melakukan partisisi namun tidak cocok dengan RANGE ataupun LIST, maka kita bisa menggunakan HASH partition. Penentuan “nilai mana di taruh di partisi mana” itu diatur secara internal oleh Oracle (berdasarkan hash value).
4. Key
Partisi ini mirip dengan partisi HASH, perbedaannya hash menggunakan algoritma fungsi mysql standar yaitu MOD. sedangkan partisi key menggunakan algoritma yang memang didesain untuk data yang memiliki key jadi partisi ini digunakan untuk kolom yang memiliki key.

# Implementasi Partisi pada database Vertabelo
pada kasus ini kami menggunakan database vertabelo 


## Mengecek apakah plugin partition telah aktif (command dan screenshot hasil)
```
SHOW PLUGINS 
atau
INFORMATION_SCHEMA.PLUGINS
```
[ss]

## Create partitiuat tabel dan contoh insert data dan hasil query-nya
