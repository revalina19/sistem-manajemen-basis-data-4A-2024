CREATE DATABASE perpustakaan;

USE perpustakaan;

CREATE TABLE anggota (
  IdAnggota VARCHAR(10) PRIMARY KEY,
  Nama_Anggota VARCHAR(20) NOT NULL,
  Tempat_Lahir_Anggota VARCHAR(20) NOT NULL,
  Tanggal_Lahir_Anggota DATE NOT NULL,
  Angkatan_Anggota VARCHAR(6) NOT NULL,
  Jenis_Kelamin VARCHAR(15) NOT NULL,
  Status_Pinjam VARCHAR(15) NOT NULL
);

CREATE TABLE petugas (
  IdPetugas VARCHAR(10) PRIMARY KEY,
  Username VARCHAR(15) NOT NULL,
  PASSWORD VARCHAR(15) NOT NULL,
  Nama VARCHAR(25) NOT NULL
);

CREATE TABLE buku (
  Kode_Buku VARCHAR(10) PRIMARY KEY,
  Judul_Buku VARCHAR(25) NOT NULL,
  Pengarang_Buku VARCHAR(30) NOT NULL,
  Penerbit_Buku VARCHAR(30) NOT NULL,
  Tahun_Buku VARCHAR(10) NOT NULL,
  Klasifikasi_Buku VARCHAR(20) NOT NULL,
  Status_Buku VARCHAR(10) NOT NULL
);

CREATE TABLE peminjaman (
  Kode_Peminjaman VARCHAR(10) PRIMARY KEY,
  IdAnggota VARCHAR(10) NOT NULL,
  Kode_Buku VARCHAR(10) NOT NULL,
  Tanggal_Pinjam DATE NOT NULL,
  Tanggal_Kembali DATE,
  IdPetugas VARCHAR(10),
  Jumlah_Buku VARCHAR(5) NOT NULL,
  FOREIGN KEY (IdAnggota) REFERENCES anggota(IdAnggota),
  FOREIGN KEY (Kode_Buku) REFERENCES buku(Kode_Buku),
  FOREIGN KEY (IdPetugas) REFERENCES petugas(IdPetugas)
);

CREATE TABLE pengembalian (
  Kode_Kembali VARCHAR(10) PRIMARY KEY,
  Kode_Peminjaman VARCHAR(10) NOT NULL,
  Tgl_Pinjam DATE NOT NULL,
  Tgl_Kembali DATE NOT NULL,
  IdPetugas VARCHAR(10),
  IdAnggota VARCHAR(10) NOT NULL,
  Denda VARCHAR(15),
  FOREIGN KEY (Kode_Peminjaman) REFERENCES peminjaman(Kode_Peminjaman),
  FOREIGN KEY (IdPetugas) REFERENCES petugas(IdPetugas),
  FOREIGN KEY (IdAnggota) REFERENCES anggota(IdAnggota)
);

INSERT INTO anggota (IdAnggota, Nama_Anggota, Tempat_Lahir_Anggota, Tanggal_Lahir_Anggota, Angkatan_Anggota, Jenis_Kelamin, Status_Pinjam) 
VALUES
('A001', 'John Doe', 'Jakarta', '1990-05-15', '2010', 'Laki-laki', 'Tidak Pinjam'),
('A002', 'Jane Smith', 'Bandung', '1992-08-20', '2012', 'Perempuan', 'Tidak Pinjam'),
('A003', 'Michael Johnson', 'Surabaya', '1988-03-10', '2009', 'Laki-laki', 'Tidak Pinjam'),
('A004', 'Emily Davis', 'Medan', '1995-11-25', '2014', 'Perempuan', 'Tidak Pinjam'),
('A005', 'Daniel Brown', 'Yogyakarta', '1993-09-05', '2011', 'Laki-laki', 'Tidak Pinjam');

INSERT INTO petugas (IdPetugas, Username, PASSWORD, Nama)
VALUES
('P001', 'admin1', 'password1', 'Admin 1'),
('P002', 'admin2', 'password2', 'Admin 2'),
('P003', 'staff1', 'passstaff1', 'Staff 1'),
('P004', 'staff2', 'passstaff2', 'Staff 2'),
('P005', 'staff3', 'passstaff3', 'Staff 3');

INSERT INTO buku (Kode_Buku, Judul_Buku, Pengarang_Buku, Penerbit_Buku, Tahun_Buku, Klasifikasi_Buku, Status_Buku)
VALUES
('B001', 'Harry Potter and the Philosopher\'s Stone', 'J.K. Rowling', 'Bloomsbury Publishing', '1997', 'Fiksi Fantasi', 'Tersedia'),
('B002', 'To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', '1960', 'Fiksi Realistis', 'Tersedia'),
('B003', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Charles Scribner\'s Sons', '1925', 'Fiksi Realistis', 'Tidak Tersedia'),
('B004', '1984', 'George Orwell', 'Secker & Warburg', '1949', 'Fiksi Sains', 'Tersedia'),
('B005', 'Pride and Prejudice', 'Jane Austen', 'T. Egerton, Whitehall', '1813', 'Fiksi Romantis', 'Tersedia');

INSERT INTO peminjaman (Kode_Peminjaman, IdAnggota, Kode_Buku, Tanggal_Pinjam, Tanggal_Kembali, IdPetugas, Jumlah_Buku)
VALUES
('PJ001', 'A001', 'B001', '2024-04-01', '2024-04-15', 'P001', '1'),
('PJ002', 'A002', 'B002', '2024-04-03', '2024-04-17', 'P002', '2'),
('PJ003', 'A003', 'B003', '2024-04-05', '2024-04-20', 'P003', '1'),
('PJ004', 'A004', 'B004', '2024-04-07', '2024-04-22', 'P004', '3'),
('PJ005', 'A005', 'B005', '2024-04-09', '2024-04-24', 'P005', '1');

INSERT INTO pengembalian (Kode_Kembali, Kode_Peminjaman, Tgl_Pinjam, Tgl_Kembali, IdPetugas, IdAnggota, Denda)
VALUES
('PK001', 'PJ001', '2024-04-01', '2024-04-15', 'P001', 'A001', '0'),
('PK002', 'PJ002', '2024-04-03', '2024-04-17', 'P002', 'A002', '0'),
('PK003', 'PJ003', '2024-04-05', '2024-04-20', 'P003', 'A003', '0'),
('PK004', 'PJ004', '2024-04-07', '2024-04-22', 'P004', 'A004', '0'),
('PK005', 'PJ005', '2024-04-09', '2024-04-24', 'P005', 'A005', '0');



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
CALL PeriksaDendaMahasiswa('A001'); 


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

