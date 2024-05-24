USE perpustakaan;

-- Soal 1
DELIMITER //

CREATE PROCEDURE SearchPengembalian(INOUT cari_data DATE)
BEGIN
    SELECT pk.kode_Kembali, pk.id_Anggota, a.nama_anggota, pk.kode_buku, 
    pk.id_petugas, p.nama, pk.tanggal_pinjam, pk.tanggal_kembali, pk.denda
    FROM pengembalian pk
    JOIN anggota a ON pk.id_anggota = a.id_anggota
    JOIN petugas p ON pk.id_petugas = p.id_petugas
    WHERE pk.tanggal_kembali = cari_data;
END //

DELIMITER ;
SET @cari_data = '2024-03-01';
CALL SearchPengembalian(@cari_data);

DROP PROCEDURE SearchPengembalian;

SELECT * FROM anggota;
SELECT * FROM petugas;
SELECT * FROM pengembalian; 

-- Soal 2
DELIMITER//
CREATE PROCEDURE Searchanggota(INOUT select_data VARCHAR(20))
BEGIN
	SELECT id_anggota, 
	    nama_anggota, 
            angkatan_anggota, 
            tempat_lahir, 
            tanggal_lahir, 
            no_telp, 
            jenis_kelamin, 
            status_pinjaman FROM anggota a WHERE a.status_pinjaman = select_data;
END//
DELIMITER;
SET @select_data = 'pinjam';
CALL Searchanggota(@select_data);
DROP PROCEDURE searchanggota;

-- Soal 3

DELIMITER //

CREATE PROCEDURE GetAnggotaByStatus(
    IN status_pinjaman_in VARCHAR(20),
    OUT jumlah_hasil INT
)
BEGIN

    SELECT 
        id_anggota, 
        nama_anggota, 
        angkatan_anggota, 
        tempat_lahir, 
        tanggal_lahir, 
        no_telp, 
        jenis_kelamin, 
        status_pinjaman 
    FROM 
        anggota 
    WHERE 
        status_pinjaman = status_pinjaman_in;
    
    -- Menghitung jumlah hasil
    SELECT COUNT(*) INTO jumlah_hasil
    FROM anggota
    WHERE status_pinjaman = status_pinjaman_in;
END //

DELIMITER ;


SET @jumlah_hasil = 0;


CALL GetAnggotaByStatus('pinjam', @jumlah_hasil);


SELECT @jumlah_hasil;


-- Soal 4

DROP PROCEDURE tambahbuku;


SELECT * FROM buku;



DELIMITER //

CREATE PROCEDURE TambahBuku(
    IN p_kode_buku VARCHAR(10),
    IN p_judul_buku VARCHAR(25),
    IN p_pengarang_buku VARCHAR(30),
    IN p_penerbit_buku VARCHAR(30),
    IN p_tahun_buku VARCHAR(10),
    IN p_jumlah_buku VARCHAR(5),
    IN p_status_buku VARCHAR(10),
    IN p_kategori VARCHAR(30)
)
BEGIN
    DECLARE keterangan VARCHAR(255);
    
    SELECT COUNT(*) INTO keterangan
    FROM buku 
    WHERE kode_buku = p_kode_buku;
    
    IF keterangan > 0 THEN
        SET keterangan = CONCAT('Data buku dengan kode ', p_kode_buku, ' sudah ada.');
    ELSE
        INSERT INTO buku (kode_buku, judul_buku, pengarang,penerbit, tahun_buku, jumlah_buku,status_buku,klasifikasi_buku) 
        VALUES (p_kode_buku, p_judul_buku, p_pengarang_buku,p_penerbit_buku, p_tahun_buku, p_jumlah_buku,p_status_buku,p_kategori);
        SET keterangan = CONCAT('Data buku dengan kode ', p_kode_buku, ' berhasil ditambahkan.');
    END IF;
    SELECT keterangan;
END //

DELIMITER ;

CALL TambahBuku('bk0011', 'masih pemula', 'saya','indo', '2024', '100','ada','kehidupan');
SELECT * FROM buku;
DELETE FROM buku WHERE kode_buku = 'bk0011';


-- Soal 5
DELIMITER //

CREATE PROCEDURE HapusAnggota(
    IN p_anggota_id VARCHAR(10)
)
BEGIN
    DECLARE jumlah_pinjaman INT;
    DECLARE result VARCHAR(100);

    SELECT COUNT(*) INTO jumlah_pinjaman
    FROM anggota
    WHERE id_anggota = p_anggota_id AND status_pinjaman = 'pinjam';

    IF jumlah_pinjaman > 0 THEN
        SET result = 'Tidak dapat menghapus anggota karena masih memiliki pinjaman yang belum dikembalikan.';
    ELSE
        DELETE FROM anggota WHERE id_anggota = p_anggota_id;
        SET result = 'Data anggota berhasil dihapus.';
    END IF;
    SELECT result;
END //

DELIMITER ;

CALL HapusAnggota('agt001');
SELECT * FROM pinjaman;

DELETE FROM pinjaman WHERE kode_pinjaman = 5;

SELECT * FROM anggota;

DROP PROCEDURE HapusAnggota;

-- soal 6


-- right join
SELECT * FROM pinjaman;
SELECT * FROM anggota;
SELECT * FROM buku;
CREATE VIEW BukuPeminjamanRightJoin AS
SELECT 
    b.kode_buku,
    b.judul_buku,
    b.pengarang,
    COUNT(p.kode_pinjaman) AS jumlah_peminjaman
FROM 
    buku b
RIGHT JOIN 
    pinjaman p ON b.kode_buku = p.kode_buku
GROUP BY 
    b.kode_buku, b.judul_buku, b.pengarang;
    
DROP VIEW BukuPeminjamanRightJoin;
    
SELECT * FROM BukuPeminjamanRightJoin;

-- left join
CREATE VIEW BukuPeminjamanLeftJoin AS
SELECT 
    b.kode_buku,
    b.judul_buku,
    b.pengarang,
    COUNT(p.kode_pinjaman) AS jumlah_peminjaman
FROM 
    buku b
LEFT JOIN 
    pinjaman p ON b.kode_buku = p.kode_buku
GROUP BY 
    b.kode_buku, b.judul_buku, b.pengarang;
    
SELECT * FROM BukuPeminjamanLeftJoin;

-- inner join
CREATE VIEW BukuPeminjamanInnerJoin AS
SELECT 
    b.kode_buku,
    b.judul_buku,
    b.pengarang,
    COUNT(p.kode_pinjaman) AS jumlah_peminjaman
FROM 
    buku b
INNER JOIN 
    pinjaman p ON b.kode_buku = p.kode_buku
GROUP BY 
    b.kode_buku, b.judul_buku, b.pengarang;
    
SELECT * FROM BukuPeminjamanInnerJoin;



