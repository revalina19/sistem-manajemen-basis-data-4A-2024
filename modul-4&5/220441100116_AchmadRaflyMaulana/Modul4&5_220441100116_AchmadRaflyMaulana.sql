CREATE DATABASE modul4dan5

USE modul4dan5

-- nomor 1
DELIMITER //
CREATE PROCEDURE pengembalihan_buku(
    IN cari_tanggal DATE
)
BEGIN
    SELECT p.*, a.nama_anggota, pt.nama AS nama_petugas
    FROM pengembalian p
    LEFT JOIN anggota a ON p.id_anggota = a.id_anggota
    LEFT JOIN petugas pt ON p.id_petugas = pt.id_petugas
    WHERE tgl_kembali = cari_tanggal;
END //
DELIMITER ;

CALL pengembalihan_buku('2023-10-22');
DROP PROCEDURE pengembalihan_buku;

-- nomor 2
DELIMITER //
CREATE PROCEDURE daftar_anggota(
	INOUT daftar_anggota VARCHAR (10)
)
BEGIN
	SELECT a.* 
	FROM anggota a
	NATURAL JOIN peminjaman b
	WHERE id_anggota = daftar_anggota;
END //
DELIMITER ;

SET @id_anggota = '101';
CALL daftar_anggota(@id_anggota);
DROP PROCEDURE daftar_anggota;

-- nomor 3
DELIMITER //
CREATE PROCEDURE PencarianStatusPinjam(
    IN statusPinjam VARCHAR(15),
    OUT hasil_pesan TEXT
)
BEGIN
    DECLARE anggota_list TEXT;
    
    SET anggota_list = '';
    SELECT GROUP_CONCAT(nama_anggota SEPARATOR ', ')
    INTO anggota_list
    FROM anggota
    WHERE status_pinjam = statusPinjam;

    IF anggota_list IS NOT NULL THEN
        SET hasil_pesan = CONCAT('Anggota dengan status pinjam "', statusPinjam, '": ', anggota_list);
    ELSE
        SET hasil_pesan = 'Tidak ada anggota dengan status pinjam tersebut';
    END IF;
END //
DELIMITER ;

DROP PROCEDURE PencarianStatusPinjam;
CALL PencarianStatusPinjam('Pinjam', @hasil_pesan);
SELECT @hasil_pesan;

-- nomor 4
DELIMITER //
CREATE PROCEDURE tambah_buku(
    IN p_kode_buku INT(10),
    IN p_judul_buku VARCHAR(25),
    IN p_pengarang_buku VARCHAR(30),
    IN p_penerbit_buku VARCHAR(30),
    IN p_tahun_buku VARCHAR(10),
    IN p_jumlah_buku VARCHAR(5),
    IN p_status_buku VARCHAR(10),
    IN p_klasifikasi_buku VARCHAR(20)
)
BEGIN
    DECLARE pesan VARCHAR(100);

    INSERT INTO buku (kode_buku, judul_buku, pengarang_buku, penerbit_buku, tahun_buku, jumlah_buku, status_buku, klasifikasi_buku) 
    VALUES (p_kode_buku, p_judul_buku, p_pengarang_buku, p_penerbit_buku, p_tahun_buku, p_jumlah_buku, p_status_buku, p_klasifikasi_buku);

    SET pesan = CONCAT('Data buku dengan kode ', p_kode_buku, ' berhasil ditambahkan.');
    SELECT pesan AS 'Message';
END//
DELIMITER ;

CALL tambah_buku(309, 'pak tukang', 'sinyo', 'Gramedia', '2014', '15', 'baru', 'baik');
SELECT * FROM buku;
DROP PROCEDURE tambah_buku;

-- nomor 5
DELIMITER //
CREATE PROCEDURE HapusAnggota(
    IN p_anggota_id VARCHAR(10)
)
BEGIN
    DECLARE jumlah_pinjaman INT;
    DECLARE result VARCHAR(100);

    SELECT COUNT(*) INTO jumlah_pinjaman
    FROM anggota
    WHERE id_anggota = p_anggota_id AND status_pinjam = 'Pinjam';

    IF jumlah_pinjaman > 0 THEN
        SET result = 'Tidak dapat menghapus anggota';
    ELSE
        DELETE FROM anggota WHERE id_anggota = p_anggota_id;
        SET result = 'Data anggota berhasil dihapus.';
    END IF;
    SELECT result;
END //
DELIMITER ;

DROP PROCEDURE HapusAnggota;
CALL HapusAnggota('104');

-- Nomor 6
CREATE VIEW right_join_view AS
SELECT p.kode_kembali, p.id_anggota, p.kode_buku, p.tgl_pinjam, p.tgl_kembali, p.denda,
       a.nama_anggota, b.judul_buku,
       COUNT(*) AS total
FROM pengembalian p
RIGHT JOIN anggota a ON p.id_anggota = a.id_anggota
RIGHT JOIN buku b ON p.kode_buku = b.kode_buku
GROUP BY p.kode_kembali;

SELECT * FROM right_join_view;

CREATE VIEW inner_join_view AS
SELECT p.kode_kembali, p.id_anggota, p.kode_buku, p.tgl_pinjam, p.tgl_kembali, p.denda,
       a.nama_anggota, b.judul_buku,
       COUNT(*) AS total
FROM pengembalian p
INNER JOIN anggota a ON p.id_anggota = a.id_anggota
INNER JOIN buku b ON p.kode_buku = b.kode_buku
GROUP BY p.kode_kembali;

SELECT * FROM inner_join_view;

CREATE VIEW left_join_view AS
SELECT p.kode_kembali, p.id_anggota, p.kode_buku, p.tgl_pinjam, p.tgl_kembali, p.denda,
       a.nama_anggota, b.judul_buku,
       COUNT(*) AS total
FROM pengembalian p
LEFT JOIN anggota a ON p.id_anggota = a.id_anggota
LEFT JOIN buku b ON p.kode_buku = b.kode_buku
GROUP BY p.kode_kembali;

SELECT * FROM left_join_view;