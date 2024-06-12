CREATE DATABASE penyewaan_mobil;

USE penyewaan_mobil;

CREATE TABLE IF NOT EXISTS mobil(
id_mobil INT(10) PRIMARY KEY AUTO_INCREMENT,
platno VARCHAR(15) NOT NULL,
merk VARCHAR(30) NOT NULL,
jenis VARCHAR(30) NOT NULL,
harga_sewa_perhari INT(100) NOT NULL
);

DROP TABLE mobil;
SELECT * FROM mobil;
INSERT INTO mobil VALUES
(NULL,'W 123 R', 'Nissan', 'Grand livina', '100000'),
(NULL,'L 234 B', 'Toyota', 'Inova', '200000'),
(NULL,'W 987 M', 'Toyota', 'Avanza', '100000');

CREATE TABLE IF NOT EXISTS pelanggan(
id_pelanggan INT(10) PRIMARY KEY AUTO_INCREMENT,
nama VARCHAR(30) NOT NULL,
alamat VARCHAR(30) NOT NULL,
nik int(20) NOT NULL,
no_telepon varchar(20) NOT NULL,
jenis_kelamin varchar(1) not null
);

drop table pelanggan;
select * from pelanggan;
INSERT INTO pelanggan VALUES
(NULL,'Rafly', 'Gresik', '12345678', '089688381109', 'L'),
(NULL,'Dani', 'Lamongan', '23456789', '081231456987', 'L'),
(NULL,'Birrur', 'Gresik', '98765432', '089231456345', 'L');

CREATE TABLE IF NOT EXISTS peminjaman(
id_peminjaman INT(10) PRIMARY KEY AUTO_INCREMENT,
id_mobil int(10) NOT NULL,
id_pelanggan int(10) NOT NULL,
tgl_pinjam date,
tgl_rencana_kembali date,
total_hari int(20) NOT NULL,
total_bayar int(100) not null,
tgl_kembali date,
denda int(100),
foreign key(id_mobil) references mobil(id_mobil),
foreign key(id_pelanggan) references pelanggan(id_pelanggan)
);

drop table peminjaman;
select * from peminjaman;
insert into peminjaman values
(null,'1','1','2024-05-25','2024-05-30','5','500000','2024-05-30','0'),
(NULL,'2','2','2024-05-22','2024-05-28','7','800000','2024-05-31','0'),
(NULL,'3','3','2024-05-24','2024-05-27','4','400000','2024-05-28','0'),
(NULL,'1','3','2024-05-10','2024-05-13','5','500000','2024-05-15','200000');


-- nomer 1
DELIMITER//
CREATE TRIGGER cek_tanggal_rencana_kembali 
BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.tgl_rencana_kembali <= NEW.tgl_pinjam THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal rencana kembali tidak boleh lebih awal';
    END IF;
END//
DELIMITER;

select * from peminjaman;
INSERT INTO peminjaman VALUES
(null,'1','1','2024-05-30','2024-05-25','5','500000','2024-05-30','0');
INSERT INTO peminjaman VALUES 
(null,'2','2','2024-06-10','2024-06-05','5','500000','2024-06-15','0');

-- nomer 2 
DELIMITER //
CREATE TRIGGER update_peminjaman 
BEFORE UPDATE ON peminjaman
FOR EACH ROW
BEGIN
    
    DECLARE v_harga_sewa_perhari DECIMAL(10, 2);
    
    SELECT harga_sewa_perhari
    INTO v_harga_sewa_perhari
    FROM mobil
    WHERE id_mobil = NEW.id_mobil;

    IF NEW.tgl_kembali IS NOT NULL THEN
        SET NEW.total_bayar = DATEDIFF(NEW.tgl_kembali, OLD.tgl_pinjam) * v_harga_sewa_perhari;
        
        IF NEW.tgl_kembali > OLD.tgl_rencana_kembali THEN
            SET NEW.denda = DATEDIFF(NEW.tgl_kembali, OLD.tgl_rencana_kembali) * v_harga_sewa_perhari;
        ELSE
            SET NEW.denda = 0;
        END IF;
    END IF;
END//
DELIMITER ;

UPDATE peminjaman
SET tgl_kembali = '2024-06-01'
WHERE id_peminjaman = 1;
select * from peminjaman;

-- nomer 3
DELIMITER//
CREATE TRIGGER cek_nik 
BEFORE INSERT ON pelanggan
FOR EACH ROW
BEGIN
    DECLARE nik_cek INT;
    SET nik_cek = CHAR_LENGTH(NEW.nik);
    IF nik_cek != 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang NIK harus 8 karakter';
    END IF;
END//
DELIMITER;

INSERT INTO pelanggan VALUES
(NULL,'Umi','Gresik','18273942','08123133014','P');
insert into pelanggan values
(null,'Umi','Gresik','127270866','08123133014','P');

-- nomer 4
DELIMITER//
CREATE TRIGGER cek_platno 
BEFORE INSERT ON mobil
FOR EACH ROW
BEGIN
    DECLARE plat_awal VARCHAR(2);
    DECLARE platno_cek INT;
    
    SET plat_awal = LEFT(NEW.platno, 2);
    SET platno_cek = CHAR_LENGTH(NEW.platno);
    
    IF platno_cek < 2 OR (NOT plat_awal REGEXP '^[A-Za-z]+$') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'platno tidak valid. Platno harus dimulai dengan huruf';
    END IF;
END//
DELIMITER;

INSERT INTO mobil VALUES
(NULL,'W 8654 G','Toyota','Fortuner','250000');
insert into mobil values
(null,'8654 G','Toyota','Fortuner','250000');