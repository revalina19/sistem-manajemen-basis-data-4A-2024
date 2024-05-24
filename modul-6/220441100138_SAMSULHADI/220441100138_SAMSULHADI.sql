
-- Tugas Praktikum 06
CREATE DATABASE IF NOT EXISTS db_perpustakaan;

USE db_perpustakaan;

-- Membuat tabel peminjaman
CREATE TABLE IF NOT EXISTS peminjaman (
    Kode_Peminjaman VARCHAR(10) PRIMARY KEY,
    IdAnggota VARCHAR(10),
    IdPetugas VARCHAR(10),
    Tanggal_Pinjam DATE,
    Tanggal_Kembali DATE,
    Kode_Buku VARCHAR(10),
    FOREIGN KEY (IdAnggota) REFERENCES anggota(IdAnggota),
    FOREIGN KEY (IdPetugas) REFERENCES petugas(IdPetugas),
    FOREIGN KEY (Kode_Buku) REFERENCES buku(Kode_Buku)
);

-- Membuat tabel petugas
CREATE TABLE IF NOT EXISTS petugas (
    IdPetugas VARCHAR(10) PRIMARY KEY,
    Username VARCHAR(15),
    Password VARCHAR(15),
    Nama VARCHAR(25)
);

-- Membuat tabel buku
CREATE TABLE IF NOT EXISTS buku (
    Kode_Buku VARCHAR(10) PRIMARY KEY,
    Judul_Buku VARCHAR(25),
    Pengarang_Buku VARCHAR(30),
    Penerbit_Buku VARCHAR(30),
    Tahun_Buku VARCHAR(10),
    Jumlah_Buku VARCHAR(5),
    Status_Buku VARCHAR(10),
    Klasifikasi_Buku VARCHAR(20)
);

-- Membuat tabel anggota
CREATE TABLE IF NOT EXISTS anggota (
    IdAnggota VARCHAR(10) PRIMARY KEY,
    Nama_Anggota VARCHAR(20),
    Angkatan_Anggota VARCHAR(6),
    Tempat_Lahir_Anggota VARCHAR(20),
    Tanggal_Lahir_Anggota DATE,
    No_Telp INT(12),
    Jenis_Kelamin VARCHAR(15),
    Status_Pinjam VARCHAR(15)
);

-- Membuat tabel pengembalian
CREATE TABLE IF NOT EXISTS pengembalian (
    Kode_Kembali VARCHAR(10) PRIMARY KEY,
    IdAnggota VARCHAR(10),
    Kode_Buku VARCHAR(10),
    IdPetugas VARCHAR(10),
    Tgl_Pinjam DATE,
    Tgl_Kembali DATE,
    Denda VARCHAR(15),
    FOREIGN KEY (IdAnggota) REFERENCES anggota(IdAnggota),
    FOREIGN KEY (Kode_Buku) REFERENCES buku(Kode_Buku),
    FOREIGN KEY (IdPetugas) REFERENCES petugas(IdPetugas)
);

--SOAL 1
DELIMITER //
CREATE PROCEDURE ShowBiodata(
    IN Nim INT,
    IN Nama_Mahasiswa VARCHAR(100),
    IN Alamat VARCHAR(255),
    IN No_Telp VARCHAR(20),
    IN Jenis_Kelamin VARCHAR(10),
    IN Hobi VARCHAR(100),
    IN Tanggal_Lahir DATE
)
BEGIN
    DECLARE Umur INT;

    SET Umur = YEAR(CURDATE()) - YEAR(Tanggal_Lahir);

    SELECT 
        Nim AS Nim,
        Nama_Mahasiswa AS Nama_Mahasiswa,
        Alamat AS Alamat,
        No_Telp AS No_Telp,
        Jenis_Kelamin AS Jenis_Kelamin,
        Hobi AS Hobi,
        Umur AS Umur_Sekarang,
        Tanggal_Lahir AS Tanggal_Lahir;
END //
DELIMITER ;
CALL ShowBiodata(1, 'Samsul Hadi', 'Jl. Raya Telang No. 4', '08123456789', 'Laki-Laki', 'Ngoding', '2004-04-15');
DROP PROCEDURE IF EXISTS ShowBiodata;


--SOAL 2
DELIMITER //
CREATE PROCEDURE ReminderReturn(
    IN vKode VARCHAR(10)
    )
BEGIN
    DECLARE selisih INT;
    
    SELECT DATEDIFF(CURDATE(),Tanggal_Pinjam) INTO selisih FROM Peminjaman WHERE Kode_Peminjaman = vKode;

    IF selisih <= 2 THEN
        SELECT 'Silahkan Pergunakan Buku dengan baik';
    ELSEIF selisih BETWEEN 3 AND 5 THEN
        SELECT 'Ingat!, Waktu Pinjam segera habis';
    ELSE
        SELECT 'Warning!!!, Denda Menanti Anda';
    END IF;
END //
DELIMITER ;

CALL ReminderReturn('PJ017');
SELECT * FROM Peminjaman;
INSERT INTO Peminjaman VALUES ('PJ017', 'A003', 'P002', '2024-05-07', '2024-05-17', 'B005');
DROP PROCEDURE IF EXISTS ReminderReturn;

--SOAL 3
DELIMITER //
CREATE PROCEDURE CheckDendaMahasiswa(IN MahasiswaID VARCHAR(10))
BEGIN
    DECLARE totalDenda INT;

    SELECT SUM(Denda) INTO totalDenda FROM Pengembalian WHERE IdAnggota = MahasiswaID;

    IF totalDenda = 0 THEN
        SELECT 'Mahasiswa tidak memiliki tanggungan atau denda';
    ELSE
        SELECT totalDenda;
    END IF;
END //
DELIMITER ;

CALL CheckDendaMahasiswa('A001');
SELECT * FROM Pengembalian;
DROP PROCEDURE IF EXISTS CheckDendaMahasiswa;

--SOAL 4
DELIMITER //
CREATE PROCEDURE PrintPeminjaman(IN lopp INT)
BEGIN
    DECLARE counter INT DEFAULT 1;

    WHILE counter <= lopp DO
        SELECT * FROM Peminjaman WHERE Kode_Peminjaman = CONCAT('PJ', LPAD(counter, 3, '0'));
        SET counter = counter + 1;
    END WHILE;
END //
DELIMITER ;

CALL PrintPeminjaman(10);
DROP PROCEDURE IF EXISTS PrintPeminjaman;

--SOAL 5
DELIMITER //
CREATE PROCEDURE DeleteMaleMembersWithNonZeroStatus()
BEGIN
    DELETE FROM Anggota
    WHERE Jenis_Kelamin = 'Laki-laki' 
    AND IdAnggota NOT IN (SELECT IdAnggota FROM Pengembalian WHERE Denda != '0');
END //
DELIMITER ;

START TRANSACTION; 
CALL DeleteMaleMembersWithNonZeroStatus();
SELECT * FROM Pengembalian;
SELECT * FROM Anggota;
COMMIT;
ROLLBACK;

DROP PROCEDURE IF EXISTS DeleteMaleMembersWithNonZeroStatus;

