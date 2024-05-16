-- Buat database
CREATE DATABASE library;

-- Gunakan database yang baru dibuat
USE library;

-- Buat tabel anggota
CREATE TABLE anggota (
    IdAnggota VARCHAR(10) PRIMARY KEY,
    Nama_Anggota VARCHAR(20),
    Angkatan_Anggota VARCHAR(6),
    Tempat_Lahir_Anggota VARCHAR(20),
    Tanggal_Lahir_Anggota DATE,
    No_Telp INT(12),
    Jenis_Kelamin VARCHAR(15),
    Status_Pinjam VARCHAR(15)
);

-- Buat tabel petugas
CREATE TABLE petugas (
    IdPetugas VARCHAR(10) PRIMARY KEY,
    Username VARCHAR(15),
    Password VARCHAR(15),
    Nama VARCHAR(25)
);

-- Buat tabel buku
CREATE TABLE buku (
    Kode_Buku VARCHAR(10) PRIMARY KEY,
    Judul_Buku VARCHAR(25),
    Pengarang_Buku VARCHAR(30),
    Penerbit_Buku VARCHAR(30),
    Tahun_Buku VARCHAR(10),
    Jumlah_Buku VARCHAR(5),
    Status_Buku VARCHAR(10),
    Klasifikasi_Buku VARCHAR(20)
);

-- Buat tabel peminjaman
CREATE TABLE peminjaman (
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

-- Buat tabel pengembalian
CREATE TABLE pengembalian (
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

-- Isi data contoh ke tabel anggota
INSERT INTO anggota (IdAnggota, Nama_Anggota, Angkatan_Anggota, Tempat_Lahir_Anggota, Tanggal_Lahir_Anggota, No_Telp, Jenis_Kelamin, Status_Pinjam)
VALUES
('A001', 'Budi', '2019', 'Jakarta', '2000-01-01', 1234567890, 'Laki-laki', '0'),
('A002', 'Siti', '2018', 'Bandung', '1999-02-02', 1234567891, 'Perempuan', '1');

-- Isi data contoh ke tabel petugas
INSERT INTO petugas (IdPetugas, Username, Password, Nama)
VALUES
('P001', 'petugas1', 'password1', 'Ahmad'),
('P002', 'petugas2', 'password2', 'Aisyah');

-- Isi data contoh ke tabel buku
INSERT INTO buku (Kode_Buku, Judul_Buku, Pengarang_Buku, Penerbit_Buku, Tahun_Buku, Jumlah_Buku, Status_Buku, Klasifikasi_Buku)
VALUES
('B001', 'Belajar SQL', 'John Doe', 'Penerbit A', '2020', '5', 'Tersedia', '001'),
('B002', 'Pemrograman Python', 'Jane Doe', 'Penerbit B', '2019', '3', 'Tersedia', '002');

-- Isi data contoh ke tabel peminjaman
INSERT INTO peminjaman (Kode_Peminjaman, IdAnggota, IdPetugas, Tanggal_Pinjam, Tanggal_Kembali, Kode_Buku)
VALUES
('PM001', 'A001', 'P001', '2024-05-01', '2024-05-10', 'B001'),
('PM002', 'A002', 'P002', '2024-05-02', '2024-05-12', 'B002');
('PM003', 'A001', 'P001', '2024-05-03', '2024-05-13', 'B002'),
('PM004', 'A002', 'P002', '2024-05-04', '2024-05-14', 'B001'),
('PM005', 'A001', 'P001', '2024-05-05', '2024-05-15', 'B002'),
('PM006', 'A002', 'P002', '2024-05-06', '2024-05-16', 'B001'),
('PM007', 'A001', 'P001', '2024-05-07', '2024-05-17', 'B002'),
('PM008', 'A002', 'P002', '2024-05-08', '2024-05-18', 'B001'),
('PM009', 'A001', 'P001', '2024-05-09', '2024-05-19', 'B002'),
('PM010', 'A002', 'P002', '2024-05-10', '2024-05-20', 'B001');

-- Isi data contoh ke tabel pengembalian
INSERT INTO pengembalian (Kode_Kembali, IdAnggota, Kode_Buku, IdPetugas, Tgl_Pinjam, Tgl_Kembali, Denda)
VALUES
('K001', 'A001', 'B001', 'P001', '2024-05-01', '2024-05-10', '10000'),
('K002', 'A002', 'B002', 'P002', '2024-05-02', '2024-05-12', NULL);


DELIMITER //
	CREATE PROCEDURE BiodataMahasiswa()
	BEGIN
	    SELECT 
		IdAnggota AS Nim,
		Nama_Anggota AS NamaMahasiswa,
		'' AS Alamat, 
		No_Telp AS NoTelpon,
		Jenis_Kelamin,
		'' AS Hobi, 
		YEAR(CURDATE()) - YEAR(Tanggal_Lahir_Anggota) AS UmurSekarang
	    FROM 
		anggota;
	END //
DELIMITER ;
-- Eksekusi stored procedure untuk menampilkan data
CALL BiodataMahasiswa();


DELIMITER //
	CREATE PROCEDURE PengingatPengembalian()
	BEGIN
	    SELECT 
		Kode_Peminjaman,
		IdAnggota,
		Kode_Buku,
		IdPetugas,
		Tanggal_Pinjam,
		Tanggal_Kembali,
		CASE 
		    WHEN DATEDIFF(CURDATE(), Tanggal_Pinjam) <= 2 THEN 'Silahkan Pergunakan Buku dengan baik'
		    WHEN DATEDIFF(CURDATE(), Tanggal_Pinjam) BETWEEN 3 AND 5 THEN 'Ingat! Waktu Pinjam Segera Habis'
		    ELSE 'Warning!!! Denda Menanti Anda'
		END AS Pengingat
	    FROM 
		peminjaman;
	END //
DELIMITER ;
-- Eksekusi stored procedure untuk menampilkan pengingat
CALL PengingatPengembalian();


DELIMITER //
	CREATE PROCEDURE PeriksaDendaMahasiswa(IN nim VARCHAR(10))
	BEGIN
	    DECLARE denda_ada INT;

	    SELECT COUNT(*)
	    INTO denda_ada
	    FROM pengembalian
	    WHERE IdAnggota = nim AND Denda IS NOT NULL AND Denda <> '';

	    IF denda_ada > 0 THEN
		SELECT Kode_Kembali, IdAnggota, Kode_Buku, IdPetugas, Tgl_Pinjam, Tgl_Kembali, Denda
		FROM pengembalian
		WHERE IdAnggota = nim AND Denda IS NOT NULL AND Denda <> '';
	    ELSE
		SELECT CONCAT('Mahasiswa dengan NIM ', nim, ' tidak memiliki tanggungan denda.') AS Pesan;
	    END IF;
	END //

DELIMITER ;
-- Eksekusi stored procedure untuk memeriksa denda mahasiswa
CALL PeriksaDendaMahasiswa('A001');  -- Ganti dengan NIM yang sesuai


DELIMITER //
CREATE PROCEDURE CetakDataPeminjaman (
    IN jumlah INT
)
BEGIN
    DECLARE ulang INT DEFAULT 1;

    WHILE ulang <= jumlah DO
        SELECT * FROM peminjaman LIMIT jumlah;
        SET ulang = ulang + 1;
    END WHILE;
END//
DELIMITER ;
CALL CetakDataPeminjaman(10);


DELIMITER //
	CREATE PROCEDURE HapusAnggotaLakiLaki()
	BEGIN
	    DECLARE rows_deleted INT DEFAULT 0;
	    
	    -- Hapus anggota laki-laki dengan status pinjam nol dan simpan jumlah baris yang dihapus
	    DELETE FROM anggota
	    WHERE Jenis_Kelamin = 'Laki-laki' AND Status_Pinjam = '1';
	    
	    -- Dapatkan jumlah baris yang dihapus
	    SET rows_deleted = ROW_COUNT();
	    
	    -- Berikan keterangan jika berhasil atau gagal
	    IF rows_deleted > 0 THEN
		SELECT CONCAT('Berhasil menghapus ', rows_deleted, ' anggota laki-laki dengan status pinjam nol.') AS result;
	    ELSE
		SELECT 'Tidak ada anggota laki-laki dengan status pinjam nol yang ditemukan untuk dihapus.' AS result;
	    END IF;
	END //
DELIMITER ;
CALL HapusAnggotaLakiLaki();


-- Menghapus stored procedure BiodataMahasiswa
DROP PROCEDURE IF EXISTS BiodataMahasiswa;

-- Menghapus stored procedure PengingatPengembalian
DROP PROCEDURE IF EXISTS PengingatPengembalian;

-- Menghapus stored procedure PeriksaDendaMahasiswa
DROP PROCEDURE IF EXISTS PeriksaDendaMahasiswa;

-- Menghapus stored procedure CetakDataPeminjaman
DROP PROCEDURE IF EXISTS CetakDataPeminjaman;

-- Menghapus stored procedure HapusAnggotaLakiLaki
DROP PROCEDURE IF EXISTS HapusAnggotaLakiLaki;