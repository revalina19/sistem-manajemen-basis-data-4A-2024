USE perpustakaan;
-- no 1
DELIMITER //

CREATE PROCEDURE carikembali(
    INOUT tanggal DATE
)
BEGIN
    SELECT 
        p.kode_kembali,
        p.id_anggota,
        a.nama_anggota,
        p.kode_buku,
        p.id_petugas,
        t.nama AS nama_petugas,
        p.tgl_pinjam,
        p.tgl_kembali,
        p.denda
    FROM 
        pengembalian p
    JOIN 
        anggota a ON p.id_anggota = a.id_anggota
    JOIN 
        petugas t ON p.id_petugas = t.id_petugas
    WHERE 
        p.tgl_kembali = tanggal;
END //

DELIMITER ;

SET @tanggal = '2023-10-21';
SELECT @tanggal;
DROP PROCEDURE carikembali;

SELECT * FROM pengembalian;

-- no 2

DELIMITER //

CREATE PROCEDURE menampilkananggota(
    INOUT status_pinjaman VARCHAR(30)
)
BEGIN
    SELECT * FROM anggota
    WHERE status_pinjam = status_pinjaman;
END //

DELIMITER ;

DROP PROCEDURE menampilkananggota;
SET @status_pinjaman = 'pinjam';
CALL menampilkananggota(@status_pinjaman);
SELECT @status_pinjaman;


-- no 3

DELIMITER//
CREATE PROCEDURE daftar_anggota(
	IN statusp VARCHAR(50))
BEGIN 
	SELECT * FROM anggota WHERE 
        status_pinjam = statusp;
	
END//
DELIMITER//

SET @statusp = 'tidak pinjam';
CALL daftar_anggota(@statusp);

DROP PROCEDURE daftar_anggota;

-- no 4

DELIMITER //

CREATE PROCEDURE insertbuku(
    IN kode_buku INT (10),
    IN judul_buku VARCHAR(25),
    IN pengarang_buku VARCHAR(30),
    IN penerbit_buku VARCHAR(30),
    IN tahun_buku VARCHAR (10),
    IN jumlah_buku VARCHAR (5),
    IN status_buku VARCHAR (10),
    IN klasifikasi_buku VARCHAR (20)
)
BEGIN
    INSERT INTO buku 
    VALUES (kode_buku, judul_buku, pengarang_buku, penerbit_buku, tahun_buku, jumlah_buku, status_buku, klasifikasi_buku);

    SELECT 'data buku berhasil ditambahkan.' AS 'Message';
    
END //
DELIMITER ;

DROP PROCEDURE insertbuku;

CALL insertbuku(309, 'Dilan', 'Manoj Punjabi', 'Balai Pustaka', '2022', '20', 'baik', 'fiksi');
SELECT * FROM buku;
-- no 5

DELIMITER//
CREATE PROCEDURE hapus_anggota(
	IN kode INT 
)
BEGIN 
	DECLARE periksa VARCHAR(50);
	DECLARE anggota INT;
	
	SELECT COUNT(*) INTO anggota FROM peminjaman WHERE id_anggota = kode;
	
    IF anggota = 0 THEN
	DELETE FROM anggota WHERE id_anggota = kode;
        SET periksa = 'anggota berhasil dihapus';
    ELSE 
        SET periksa = 'anggota gagal dihapus';
    END IF;
    
    SELECT periksa;
	
END//
DELIMITER ;

CALL hapus_anggota(101);

SELECT * FROM anggota;

DROP PROCEDURE hapus_anggota;


-- no 6
-- A

CREATE VIEW vw_totalbukudikembalikan AS
SELECT a.id_anggota, a.nama_anggota, COUNT(*) AS total_dikembalikan
FROM anggota a
INNER JOIN pengembalian p ON a.id_anggota = p.id_anggota
GROUP BY a.id_anggota, a.nama_anggota;

SELECT * FROM vw_totalbukudikembalikan;
DROP VIEW vw_totalbukudikembalikan;

-- B

CREATE VIEW vw_petugas_transaksi AS
SELECT t.id_petugas, t.nama, p.tanggal_pinjam, p.tanggal_kembali, COUNT(*) AS jumlah_transaksi
FROM petugas t
RIGHT JOIN peminjaman p ON t.id_petugas = p.id_petugas
GROUP BY t.id_petugas, t.nama
ORDER BY jumlah_transaksi ASC;

SELECT * FROM vw_petugas_transaksi;

-- C

CREATE VIEW vw_jumlahmeminjam AS
SELECT a.id_anggota, a.nama_anggota, COUNT(*) AS jumlah_meminjam
FROM anggota a
LEFT JOIN peminjaman p ON a.id_anggota = p.id_anggota
GROUP BY a.id_anggota, a.nama_anggota
ORDER BY jumlah_meminjam DESC;

SELECT * FROM vw_jumlahmeminjam;

DROP VIEW vw_jumlahmeminjam;