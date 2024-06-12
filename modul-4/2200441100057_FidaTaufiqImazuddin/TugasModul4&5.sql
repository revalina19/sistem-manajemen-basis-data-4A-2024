-- TUGAS PRAKTIKUM MODUL 4 & 5 --
USE library4;

-- 1.
DELIMITER //
CREATE PROCEDURE cari_berdasarkan_tanggal(
	INOUT tanggal_cari DATE)	
BEGIN
	SELECT 
        p.kode_kembalian,
        p.idAnggota,
        a.nama_anggota,
        p.idPetugas,
        t.nama AS nama_petugas,
        p.kode_buku,
        p.Tgl_Pinjam,
        p.Tgl_Kembalian,
        p.Denda
    FROM 
        pengembalian p
    JOIN anggota a ON p.idAnggota = a.idAnggota
    JOIN petugas t ON p.idPetugas = t.idPetugas
    WHERE p.Tgl_Kembalian = tanggal_cari;

END//
DELIMITER;

SET @tanggal_cari = '2024-03-20'; 
CALL cari_berdasarkan_tanggal(@tanggal_cari);

DROP PROCEDURE cari_berdasarkan_tanggal;

-- 2.
DELIMITER //
CREATE PROCEDURE cari_anggota(
	INOUT status_peminjaman VARCHAR(100))
BEGIN
	SELECT * FROM anggota WHERE status_pinjam = status_peminjaman;
END //
DELIMITER;

SET @status_peminjaman = 'Belum Meminjam';
CALL cari_anggota(@status_peminjaman);

DROP PROCEDURE cari_anggota;

-- 3.
DELIMITER //
CREATE PROCEDURE cari_anggota_out(
	IN statuspinjam VARCHAR (100), 
	OUT hasil TEXT)
BEGIN
	SELECT
	GROUP_CONCAT(CONCAT('ID : ', idAnggota,
			    ', Nama : ', nama_anggota, 
			    ', Status : ', status_pinjam))
	INTO hasil
	FROM anggota
	WHERE status_pinjam = statuspinjam;
END //
DELIMITER;

SET @statuspinjam = 'Sudah Meminjam';
CALL cari_anggota_out(@statuspinjam, @hasil);
SELECT @hasil;

-- 4.
DELIMITER //
CREATE PROCEDURE tambah_data_buku_IN(
    IN kodeBuku VARCHAR(10),
    IN judulBuku VARCHAR(25),
    IN pengarangBuku VARCHAR(30),
    IN penerbitBuku VARCHAR(30),
    IN tahunBuku VARCHAR(10),
    IN jumlahBuku VARCHAR(5),
    IN statusBuku VARCHAR(10),
    IN klasifikasiBuku VARCHAR(20),
    OUT pesan VARCHAR(255)
)
BEGIN
	DECLARE cek_kode_buku INT;
	
	SELECT COUNT(*) INTO cek_kode_buku
	FROM buku
	WHERE kode_buku = kodeBuku;
	
	IF cek_kode_buku > 0 THEN
		SET pesan = 'kode buku sudah ada';
	ELSE 
		INSERT INTO buku (kode_buku, judul_buku, pengarang_buku, 
		penerbit_buku, tahun_buku, jumlah_buku, status_buku, klasifikasi_buku) 
		VALUES (kodeBuku, judulBuku, pengarangBuku, 
		penerbitBuku, tahunBuku, jumlahBuku, statusBuku, klasifikasiBuku);
		
		SET pesan = CONCAT('Data buku dengan kode "', kodeBuku, '"dan judul "', 
		judulBuku, '" berhasil ditambahkan');
	END IF;
END //
DELIMITER;
DROP PROCEDURE tambah_data_buku_IN;

SET @pesan = '';
CALL tambah_data_buku_IN('BK012', 'Belajar SQL', 'Saipul ', 'Penerbit ABC', '2024', '10', 'tersedia', 'Teknologi Informasi', @pesan);
SELECT @pesan;
SELECT * FROM buku;

-- 5.
DELIMITER //
CREATE PROCEDURE hapus_data_IN(
	IN input_idAnggota VARCHAR(10))
BEGIN
	DECLARE status_pinjaman VARCHAR(20);
	
	SELECT status_pinjam INTO status_pinjaman
	FROM anggota
	WHERE idAnggota = input_idAnggota;
	
	IF status_pinjaman = 'Belum Kembali' THEN
	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Tidak dapat menghapus anggota karena masih memiliki pinjaman yang belum dikembalikan';
	ELSE 
		DELETE FROM anggota 
		WHERE idAnggota = input_idAnggota;
		
		SELECT 'Data anggota berhasil dihapus' AS 'Result';
	END IF;
END //
DELIMITER;

DROP PROCEDURE hapus_data_IN;
CALL hapus_data_IN('A011');

-- 6.
-- RIGHT JOIN
create view DetailPeminjamBuku as
	select 	b.kode_buku as idBuku,
		b.judul_buku as JudulBuku,
		count(p.kode_Peminjaman) as WaktuDipinjam
	from
		buku b
	right join peminjaman p on b.kode_buku = p.kode_buku
	group by b.kode_buku, b.judul_buku;
	
select * from DetailPeminjamBuku;
		
-- INNER JOIN
CREATE VIEW TotalBukuDipinjam AS
	select	a.idAnggota as AnggotaID,
		a.nama_anggota as NamaAnggota,
		count(p.kode_buku) as TotalBukuDipinjam
	from 
		anggota a
	inner join
		peminjaman p on a.idAnggota = p.idAnggota
	group by a.idAnggota, a.nama_anggota;
	
SELECT * FROM TotalBukuDipinjam;

-- LEFT JOIN
CREATE VIEW DipinjamDanDikembalikan AS
	SELECT	a.idAnggota AS AnggotaID,
		a.nama_anggota AS NamaAnggota,
		count(distinct p.kode_buku) as TotalBukuDipinjam,
		count(distinct k.kode_buku) as TotalBukuDikembalikan
	from 
		anggota a
	left join
		peminjaman p on a.idAnggota = p.idAnggota
	left join 
		pengembalian k on a.idAnggota = k.idAnggota
	group by
		a.idAnggota, a.nama_anggota;
		
SELECT * FROM DipinjamDanDikembalikan;