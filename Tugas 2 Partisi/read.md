# Partisi
Partisi adalah memecah tabel ke dalam beberapa segment (partisi atau subpartisi), di mana tabel konvensional hanya mempunyai satu segment.
## Catatan
Di dalam partisi tidak diperbolehkan menggunakan ```foreign key```, untuk mengatasi masalah tersebut adalah dengan mematikan atau comment ```foreign key``` didalam tabel tersebut.
# Tipe Partisi
1. Range
Data dikelompokkan berdasarkan range(rentang) nilai yang kita tentukan. Range partition ini cocok digunakan pada kolom yang nilainya terdistribusi secara merata. Contoh yang paling sering adalah kolom tanggal.
2. List
Pada list partition, data dikelompokkan berdasarkan nilainya. Cocok untuk kolom yang variasi nilainya tidak banyak.
3. Hash
Jika kita ingin melakukan partisisi namun tidak cocok dengan RANGE ataupun LIST, maka kita bisa menggunakan HASH partition. Penentuan “nilai mana di taruh di partisi mana” itu diatur secara internal oleh Oracle (berdasarkan hash value).
4. Key
Partisi ini mirip dengan partisi HASH, perbedaannya hash menggunakan algoritma fungsi mysql standar yaitu MOD. sedangkan partisi key menggunakan algoritma yang memang didesain untuk data yang memiliki key jadi partisi ini digunakan untuk kolom yang memiliki key.

# Mengecek apakah plugin partition telah aktif
membuat database baru dengan nama ```test```.
```
create database test;
```
memberikan izin agar userbdt dapat mengakses database test melalui ProxySQL.
```
GRANT SELECT on test.* to 'userbdt'@'%';
FLUSH PRIVILEGES;
```
![Ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%202%20Partisi/Ss/user.PNG)
mengecek Plugin partisi aktif. 
```
SHOW PLUGINS 
```
atau
```
INFORMATION_SCHEMA.PLUGINS
```

# Implementasi Partisi pada database Vertabelo
pada kasus ini kami menggunakan database vertabelo silahkan download terlebih dahulu [disini](https://drive.google.com/file/d/0B2Ksz9hP3LtXRUppZHdhT1pBaWM/view) 
## 1. Range Partition
membuat tabel rc1.
```
CREATE TABLE rc1 (
    a INT,
    b INT
)
PARTITION BY RANGE COLUMNS(a, b) (
    PARTITION p0 VALUES LESS THAN (5, 12),
    PARTITION p3 VALUES LESS THAN (MAXVALUE, MAXVALUE)
);
```
menambahkan value ke table rc1.
```
INSERT INTO rc1 (a,b) VALUES (4,11);
INSERT INTO rc1 (a,b) VALUES (5,11);
INSERT INTO rc1 (a,b) VALUES (6,11);
INSERT INTO rc1 (a,b) VALUES (4,12);
INSERT INTO rc1 (a,b) VALUES (5,12);
INSERT INTO rc1 (a,b) VALUES (6,12);
INSERT INTO rc1 (a,b) VALUES (4,13);
INSERT INTO rc1 (a,b) VALUES (5,13);
INSERT INTO rc1 (a,b) VALUES (6,13);
```
melihat isi tabel rc1 ```Select * from rc1```

![Ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%202%20Partisi/Ss/showisitable.png)

melakukan select dimana nilai yang <= 5,12 akan masuk pada p0 sesuai dengan partisi yang digunakan.
```
SELECT *,'p0' FROM rc1 PARTITION (p0) UNION ALL SELECT *,'p3' FROM rc1 PARTITION (p3) ORDER BY a,b ASC;
```
![Ss](https://github.com/Nirmala01/Basis-Data-Terdistribusi-BDT-/blob/master/Tugas%202%20Partisi/Ss/showpartisi.png)

## 2. Lish Partition
```
CREATE TABLE serverlogs (
    serverid INT NOT NULL, 
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL
)
PARTITION BY LIST (serverid)(
    PARTITION server_east VALUES IN(1,43,65,12,56,73),
    PARTITION server_west VALUES IN(534,6422,196,956,22)
);
```
## 3. Hash Partision
```CREATE TABLE serverlogs2 (
    serverid INT NOT NULL, 
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL
)
PARTITION BY HASH (serverid)
PARTITIONS 10;
```
## 4. Key Partition
```
CREATE TABLE serverlogs4 (
    serverid INT NOT NULL, 
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL,
    UNIQUE KEY (serverid)
)
PARTITION BY KEY()
PARTITIONS 10;
```

# Testing pada Range Partition
### Gunakan perintah EXPLAIN untuk melihat plan eksekusi query untuk masing-masing tabel.
> EXPLAIN tanpa Partisi.
```
EXPLAIN SELECT *
FROM test.measures
WHERE measure_timestamp >= '2016-01-01' AND DAYOFWEEK(measure_timestamp) = 1;
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.06.20%20AM.png)
> EXPLAIN dengan Partisi.
```
EXPLAIN PARTITIONS SELECT *
FROM test.partitioned_measures
WHERE measure_timestamp >= '2016-01-01' AND DAYOFWEEK(measure_timestamp) = 1;
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.07.03%20AM.png)
### Jalankan query benchmark untuk masing-masing tabel. Hasilnya adalah running time.
> Select Benchmark tanpa Partisi.
```
SELECT SQL_NO_CACHE
    COUNT(*)
FROM
    test.measures
WHERE
    measure_timestamp >= '2016-01-01'
        AND DAYOFWEEK(measure_timestamp) = 1;
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.07.45%20AM.png)
> Select Benchmark dengan partisi.
``` 
SELECT SQL_NO_CACHE
    COUNT(*)
FROM
    test.partitioned_measures
WHERE
    measure_timestamp >= '2016-01-01'
        AND DAYOFWEEK(measure_timestamp) = 1;
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.08.19%20AM.png)
### Jalankan query delete (bagian BIG DELETE) dan tampilkan perbedaan running time-nya.
> Menambah data tanpa Partisi.
```
ALTER TABLE `test`.`measures` 
ADD INDEX `index1` (`measure_timestamp` ASC);
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.20.28%20AM.png)
> Menghapus data tanpa Partisi.
```
ALTER TABLE `test`.`measures` 
DROP INDEX `measure_timestamp` ;
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.19.18%20AM.png)
> Menambah data dengan Partisi.
```
ALTER TABLE `test`.`partitioned_measures` 
ADD INDEX `index1` (`measure_timestamp` ASC);
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.20.41%20AM.png)
> Menghapus data dengan Partisi.
```
ALTER TABLE `test`.`partitioned_measures` 
DROP INDEX `measure_timestamp` ;
```
![Ss](https://github.com/Nirmala01/BDT/blob/master/Tugas%202%20Partisi/Ss/Screen%20Shot%202019-03-20%20at%204.20.09%20AM.png)
# Referensi
https://www.vertabelo.com/blog/technical-articles/everything-you-need-to-know-about-mysql-partitions
