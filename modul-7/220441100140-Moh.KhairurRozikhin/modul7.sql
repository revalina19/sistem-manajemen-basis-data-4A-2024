DROP DATABASE sewa;

CREATE DATABASE sewa;

USE sewa;

CREATE TABLE mobil (
Id_Mobil INT (10) PRIMARY KEY ,
platno VARCHAR(100),
merk VARCHAR(100),
jenis VARCHAR (100),
Harga_Sewa_Perhari INT(12)
);

DROP TABLE mobil;

CREATE TABLE peminjaman (
id INT (10) PRIMARY KEY,
Id_Mobil INT(10),
Id_Pelanggan INT(10),
tgl_pinjam DATE,
tgl_rencana_kembali DATE,
total_hari INT(10),
total_bayar INT(12),
tgl_kembali DATE,

denda INT (12)
);

CREATE TABLE pelanggan (
Id_Pelanggan INT(10) PRIMARY KEY,
nama VARCHAR(100),
alamat VARCHAR(100),
NIK VARCHAR(100),
No_telphone VARCHAR(100),
Jenis_Kelamin VARCHAR (1)
);

ALTER TABLE peminjaman 
ADD CONSTRAINT FK_MobilPeminjaman
FOREIGN KEY (Id_Mobil) REFERENCES mobil(Id_Mobil);

ALTER TABLE peminjaman 
ADD CONSTRAINT FK_pelangganPeminjaman
FOREIGN KEY (Id_Pelanggan) REFERENCES Pelanggan(Id_Pelanggan);


INSERT INTO mobil (Id_Mobil, platno, merk, jenis, Harga_Sewa_Perhari) VALUES
(1, 'B2 1234 AB', 'Toyota', 'Sedan', 500000),
(2, 'D3 5678 DE', 'Honda', 'SUV', 600000),
(3, 'B5 9101 GH', 'Suzuki', 'Hatchback', 400000),
(4, 'L8 1121 JK', 'Ford', 'Truck', 700000),
(5, 'F6 3141 MN', 'BMW', 'Coupe', 1000000),
(6, 'B9 5161 PQ', 'Mercedes', 'Convertible', 1200000),
(7, 'H4 7181 ST', 'Nissan', 'Minivan', 550000),
(8, 'B1 9202 VW', 'Chevrolet', 'SUV', 650000),
(9, 'D6 1222 YZ', 'Kia', 'Sedan', 450000),
(10, 'B7 3242 BD', 'Hyundai', 'SUV', 600000);


INSERT INTO pelanggan (Id_Pelanggan, nama, alamat, NIK, No_telphone, Jenis_Kelamin) VALUES
(1, 'John Doe', 'Jl. Kebon Jeruk No. 12', 123456789012, '081234567890', 'M'),
(2, 'Jane Smith', 'Jl. Melati No. 34', 234567890123, '082345678901', 'F'),
(3, 'Michael Johnson', 'Jl. Mawar No. 56', 345678901234, '083456789012', 'M'),
(4, 'Emily Davis', 'Jl. Kenanga No. 78', 456789012345, '084567890123', 'F'),
(5, 'William Brown', 'Jl. Flamboyan No. 90', 567890123456, '085678901234', 'M'),
(6, 'Olivia Wilson', 'Jl. Anggrek No. 11', 678901234567, '086789012345', 'F'),
(7, 'James Miller', 'Jl. Bougenville No. 23', 789012345678, '087890123456', 'M'),
(8, 'Ava Martinez', 'Jl. Dahlia No. 45', 890123456789, '088901234567', 'F'),
(9, 'Lucas Anderson', 'Jl. Kamboja No. 67', 901234567890, '089012345678', 'M'),
(10, 'Sophia Hernandez', 'Jl. Teratai No. 89', 123450987654, '081223344556', 'F');


INSERT INTO peminjaman (id, Id_Mobil, Id_Pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda) VALUES
(1, 1, 1, '2024-01-01', '2024-01-03', 2, 1000000, '2024-01-03', 0),		
(2, 2, 2, '2024-01-02', '2024-01-05', 3, 1800000, '2024-01-05', 0),
(3, 3, 3, '2024-01-03', '2024-01-06', 3, 1200000, '2024-01-06', 0),
(4, 4, 4, '2024-01-04', '2024-01-07', 3, 2100000, '2024-01-07', 0),
(5, 5, 5, '2024-01-05', '2024-01-08', 3, 3000000, '2024-01-08', 0),
(6, 6, 6, '2024-01-06', '2024-01-09', 3, 3600000, '2024-01-09', 0),
(7, 7, 7, '2024-01-07', '2024-01-10', 3, 1650000, '2024-01-10', 0),
(8, 8, 8, '2024-01-08', '2024-01-11', 3, 1950000, '2024-01-11', 0),
(9, 9, 9, '2024-01-09', '2024-01-12', 3, 1350000, '2024-01-12', 0),
(10, 10, 10, '2024-01-10', '2024-01-13', 3, 1800000, '2024-01-13', 0);


/*soal 1*/
DELIMITER //
CREATE TRIGGER tugas1 BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
IF (new.tgl_pinjam > new.tgl_rencana_kembali) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Tanggal Rencana Kembali Tidak Lebih Awal dari Tanggal Pinjam!';
END IF;
END//
DELIMITER ;
INSERT INTO peminjaman (id, Id_Mobil, id_pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda) VALUES
(12, 2, 4, '2023-05-18', '2023-05-15', 5, 1500000, '2023-05-15', 0);

SELECT * FROM peminjaman;

CREATE TABLE up_peminjaman(
Id_pinjam VARCHAR(20) NOT NULL PRIMARY KEY,
Total_hari INT,
Total_bayar INT,
Tgl_kembali DATE NOT NULL,
Denda INT NOT NULL
);

/*soal2*/
DELIMITER //
CREATE TRIGGER up_pengembalian AFTER INSERT ON up_peminjaman 
FOR EACH ROW
BEGIN
UPDATE peminjaman SET total_hari = new.total_hari, total_bayar = new.total_bayar,
tgl_kembali = new.tgl_kembali, denda = new.denda WHERE id = new.Id_pinjam;
END//
DELIMITER ;


SELECT * FROM peminjaman
DROP TRIGGER up_pengembalian;
INSERT INTO up_peminjaman VALUES ('3', 3, 1200000, "2023-05-20", 70000);

SELECT*FROM up_peminjaman;
INSERT INTO up_peminjaman VALUES ('7', 4, 1000000, "2023-06-18", 50000);

INSERT INTO up_peminjaman VALUES ('1', 1, 2000000, "2023-02-18", 50000);

INSERT INTO up_peminjaman VALUES ('2', 2, 2000000, "2023-02-18", 40000);
SELECT*FROM up_peminjaman;
SELECT*FROM peminjaman;


/*soal 3*/
DELIMITER //
CREATE TRIGGER cek_nik
BEFORE INSERT ON pelanggan
FOR EACH ROW
BEGIN
IF (LENGTH(new.nik) < 10 OR LENGTH(new.nik) > 10)
THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = "Panjang NIK Harus Sesuai Aturan yang Berlaku!";
END IF;
END // 
DELIMITER ;

INSERT INTO pelanggan VALUES ('20', 'Narendra', 'Jombang', '342518807967228','084667876590', 'Laki-laki');
INSERT INTO pelanggan VALUES ('111', 'rozikhin', 'Bangkalan', '7657893728','084667876591', 'Laki - Laki');

SELECT * FROM pelanggan;

/*soal4*/
DELIMITER //
CREATE TRIGGER cek_platno BEFORE INSERT ON mobil FOR EACH ROW
BEGIN
IF (new.platno NOT REGEXP'^[a-zA-Z]' AND new.platno NOT REGEXP'^[a-zA-Z][a-zA-Z]')
THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = "1/2 Karater Awal Plat Nomor Harus Huruf!";
END IF;
END//
DELIMITER ;

INSERT INTO mobil VALUES ('11', '1J 9999 KL', 'Suzuki', 'Ayla', 300000);
INSERT INTO mobil VALUES ('11', 'AB 9999 KL', 'Suzuki', 'Ayla', 300000);

SELECT * FROM mobil


