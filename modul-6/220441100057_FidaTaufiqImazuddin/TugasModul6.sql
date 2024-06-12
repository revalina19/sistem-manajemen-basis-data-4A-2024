-- 1. --
USE tugas_modul_enam;
SELECT * FROM anggota;

DELIMITER //
CREATE PROCEDURE biodata(
	IN nim INT,
	IN nam VARCHAR(20),
	IN almt VARCHAR(40),
	IN tgll DATE,
	IN umur INT,
	IN tlp VARCHAR(20),
	IN jk VARCHAR(20),
	IN hb VARCHAR(80))
BEGIN
	DECLARE nrp INT;
	DECLARE nama VARCHAR(20);
	DECLARE alamat VARCHAR(40);
	DECLARE tgl_lahir DATE;
	DECLARE umur INT;
	DECLARE no_tlp VARCHAR(20);
	DECLARE jenis_kelamin VARCHAR(20);
	DECLARE hobi VARCHAR(80);
	
	SET nrp = nim;
	SET nama = nam;
	SET alamat = almt;
	SET tgl_lahir = tgll;
	SET umur = TIMESTAMPDIFF(YEAR,tgll,CURDATE());
	SET no_tlp = tlp;
	SET jenis_kelamin = jk;
	SET hobi = hb;
	
	SELECT nrp AS NIM, nama AS Nama, alamat AS Alamat, tgl_lahir AS Tanggal_lahir, 
	umur AS Umur, no_tlp AS Nomor_telphon, jenis_kelamin AS Jenis_kelamin, hobi AS Hobi;
	
END //
DELIMITER;
CALL biodata(22087800,'Santos','Surabaya','2001-01-01','','086789','L','Balap Mobil');

DROP PROCEDURE biodata;

-- 2. --
SELECT * FROM peminjaman;
DELIMITER //
CREATE PROCEDURE pengingat(
	IN id_Anggota VARCHAR(10),
	IN kodeBuku VARCHAR(10))
	
BEGIN
	DECLARE pengingat VARCHAR(100);
	
	IF ((SELECT DATEDIFF(Tanggal_Kembali,Tanggal_Pinjam) AS lama_pinjam
		FROM peminjaman WHERE idAnggota=id_Anggota AND kode_buku=kodeBuku) <=2) THEN
		SET pengingat = "silahkan pergunakan buku dengan baik";
		
	ELSEIF ((SELECT DATEDIFF(Tanggal_Kembali,Tanggal_Pinjam) AS lama_pinjam
		FROM peminjaman WHERE idAnggota=id_Anggota AND kode_buku=kodeBuku) >=3  AND
		(SELECT DATEDIFF(Tanggal_Kembali,Tanggal_Pinjam) AS lama_pinjam
		FROM peminjaman WHERE idAnggota=id_Anggota AND kode_buku=kodeBuku) <=5) THEN 
		SET pengingat = "Ingat!, Waktu Pinjam Segera Habis";
		
	ELSEIF ((SELECT DATEDIFF(Tanggal_Kembali,Tanggal_Pinjam) AS lama_pinjam
		FROM peminjaman WHERE idAnggota=id_Anggota AND kode_buku=kodeBuku) >=6) THEN
		SET pengingat = "Warning!!!, Denda menanti anda.";
		
	END IF;
	SELECT pengingat;
END //
DELIMITER;
CALL pengingat('A001','BK010');

-- 3. --
DELIMITER //
CREATE PROCEDURE denda(
	IN id_Anggota VARCHAR(10))
BEGIN
	DECLARE jumlah_denda VARCHAR(100);
	
	IF ((SELECT SUM(denda) FROM pengembalian WHERE idAnggota = id_Anggota) !=0) THEN
		SET jumlah_denda = (SELECT SUM(denda) FROM pengembalian WHERE idAnggota = id_Anggota); 
	ELSE 
		SET jumlah_denda = "Anda tidak memiliki denda";
	END IF;
	SELECT jumlah_denda;
END //
DELIMITER;

CALL denda('A001');

-- 4. --
DELIMITER //
CREATE PROCEDURE cetak_peminjaman (
    IN bil INT
)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= bil DO
        SELECT * FROM peminjaman LIMIT bil;
        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;

CALL cetak_peminjaman(10);

-- 5. --
DELIMITER//
CREATE PROCEDURE hapus_anggota ()
BEGIN
	 DELETE FROM Anggota
    WHERE jenis_kelamin = 'Laki-laki'
    AND idAnggota NOT IN (
        SELECT DISTINCT idAnggota 
        FROM peminjaman 
        WHERE status_pinjam != "Belum Meminjam"
    );
END//
DELIMITER ;
CALL hapus_anggota();
SELECT * FROM anggota;
DROP PROCEDURE hapus_anggota;