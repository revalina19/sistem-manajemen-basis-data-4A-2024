USE perpustakaan;

-- -- -- -- --  SOAL 1  -- -- -- -- --
DROP PROCEDURE IF EXISTS tampilkan_biodata;
DELIMITER //
CREATE PROCEDURE tampilkan_biodata(IN Nama_atau_ID VARCHAR(200))
BEGIN
    DECLARE hobi VARCHAR(50);
    DECLARE umur INT(11);
    DECLARE tanggal_lahir VARCHAR(50);
    DECLARE gender VARCHAR(50);
    SET hobi = "Membaca";
    
    IF Nama_atau_ID REGEXP "^[0-9]+$" THEN
        SELECT Tanggal_Lahir_Anggota, Jenis_Kelamin INTO tanggal_lahir, gender FROM anggota WHERE IdAnggota = Nama_atau_ID;
    ELSE 
        SELECT Tanggal_Lahir_Anggota, Jenis_Kelamin INTO tanggal_lahir, gender FROM anggota WHERE Nama_Anggota = Nama_atau_ID;
    END IF;
    
    IF gender = "L" THEN
        SET gender = "Laki-Laki";
    ELSEIF gender = "P" THEN
        SET gender = "Perempuan";
    ELSE
        SET gender = "Tidak diketahui";
    END IF;

    SET umur = YEAR(CURDATE()) - YEAR(tanggal_lahir);
    
    SELECT `IdAnggota` AS 'NIM', 
        `Nama_Anggota` AS 'Nama Mahasiswa', 
        `Tempat_Lahir_Anggota` AS 'Alamat', 
        `No_Telp` AS 'No. Telpon', 
        gender AS 'Jenis Kelamin', 
        hobi AS 'Hobi', 
        umur AS 'Umur Sekarang'
    FROM anggota WHERE IdAnggota = Nama_atau_ID OR Nama_Anggota = Nama_atau_ID;
END //
DELIMITER ;

CALL tampilkan_biodata("200001");
CALL tampilkan_biodata("Budi Santoso");

-- -- -- -- --  SOAL 2  -- -- -- -- --
DROP PROCEDURE IF EXISTS keterangan_pengingat_pengembalian;
DELIMITER //
CREATE PROCEDURE keterangan_pengingat_pengembalian (IN Nama_Atau_IdPeminjam VARCHAR(200))
BEGIN
        SELECT 
            `Nama_Anggota` AS 'Nama Anggota',
            `Judul_Buku` AS 'Buku',
             CONCAT (DATEDIFF(CURDATE(), `Tanggal_Pinjam`), ' Hari') AS 'Lama Pinjam',
             CASE 
                WHEN `Tanggal_Kembali` IS NOT NULL THEN "Buku sudah di kembalikan"
                WHEN DATEDIFF(CURDATE(), `Tanggal_Pinjam`) <= 2 THEN "Silahkan Pergunakan Buku dengan baik" 
                WHEN DATEDIFF(CURDATE(), `Tanggal_Pinjam`) BETWEEN 3 AND 5 THEN "Ingat!, Waktu Pinjam segera habis"
                ELSE "Warning!!!, Denda Menanti Anda"
             END AS 'Keterangan'
        FROM anggota JOIN peminjaman USING (IdAnggota) JOIN buku USING(Kode_Buku) WHERE Nama_Anggota = Nama_Atau_IdPeminjam OR IdAnggota = Nama_Atau_IdPeminjam;
    
END //
DELIMITER ;

CALL keterangan_pengingat_pengembalian("Budi Santoso");
CALL keterangan_pengingat_pengembalian("200005");

-- -- -- -- --  SOAL 3  -- -- -- -- --
DROP PROCEDURE IF EXISTS cek_denda_mahasiswa;
DELIMITER //
CREATE PROCEDURE cek_denda_mahasiswa(IN Nama_Mahasiswa VARCHAR(200))
BEGIN
    DECLARE total_denda INT(11);
    
    SELECT SUM(Denda) INTO total_denda 
    FROM pengembalian 
    JOIN anggota USING (IdAnggota) 
    WHERE Nama_Anggota = Nama_Mahasiswa AND Denda > 0;
    
    IF total_denda IS NULL THEN
        SELECT 'Mahasiswa ' AS 'Keterangan', 
            Nama_Anggota AS 'Nama Mahasiswa', 
            'Tidak memiliki tanggungan atau denda' AS 'Denda'
        FROM anggota 
        WHERE Nama_Anggota = Nama_Mahasiswa;
    ELSE
        SELECT 'Mahasiswa ' AS 'Keterangan', 
            Nama_Anggota AS 'Nama Mahasiswa', 
            CONCAT('Total denda yang belum dibayar : Rp ', total_denda) AS 'Denda'
        FROM anggota 
        WHERE Nama_Anggota = Nama_Mahasiswa;
    END IF;
END //
DELIMITER ;

CALL cek_denda_mahasiswa("Budi Santoso");
CALL cek_denda_mahasiswa("Dewi Rahayu");

-- -- -- -- --  SOAL 4  -- -- -- -- --
DROP PROCEDURE IF EXISTS Cekpeminjaman;
DELIMITER //
CREATE PROCEDURE Cekpeminjaman (IN batas INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE a VARCHAR(200) DEFAULT "400001";
    -- DECLARE b INT DEFAULT 400001;
    DECLARE stmt TEXT;
    SET @sql = '';
    
    WHILE i < batas DO 
        SET a = CONCAT(a, ', ', 400001 + i);

--      SELECT * FROM peminjaman WHERE Kode_Peminjaman = b;
--         SET b = CONCAT (b + 1);
        SET i = i + 1 ;
    END WHILE;
    
    SET @sql = CONCAT('SELECT * FROM peminjaman WHERE Kode_Peminjaman IN (', a, ')');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;
-- SELECT * FROM peminjaman WHERE Kode_Peminjaman IN (400001, 400002, 400003, 400004, 400005, 400006, 400007, 400008, 400009, 400010); 
CALL Cekpeminjaman (10);

-- -- -- -- --  SOAL 5  -- -- -- -- --
DROP PROCEDURE IF EXISTS Hapus_tidak_aktif;
DELIMITER //
CREATE PROCEDURE Hapus_tidak_aktif (IN gender_l_atau_p VARCHAR(200))
BEGIN
    DECLARE baris INT;
    DECLARE pesan VARCHAR(200);
    DELETE FROM anggota WHERE Jenis_Kelamin = gender_l_atau_p AND Status_Pinjam = "Tidak Aktif";
    
    SET baris = ROW_COUNT();

    IF baris = 0 THEN
        SET pesan = 'Tidak ada data yang dihapus';
    ELSE
        SET pesan = CONCAT(baris, ' Data dihapus');
    END IF;
    SELECT pesan AS Hasil;
END //
DELIMITER ;
SET SQL_SAFE_UPDATES = 0;
CALL Hapus_tidak_aktif ("l");
