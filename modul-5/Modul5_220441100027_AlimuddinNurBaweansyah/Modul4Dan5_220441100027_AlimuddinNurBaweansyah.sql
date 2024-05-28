use perpustakaan;
-- No 1
DELIMITER //

CREATE PROCEDURE SearchPengembalianByDate(INOUT search_date DATE)
BEGIN
    SELECT pk.Kode_Kembali, pk.IdAnggota, a.Nama_Anggota, pk.Kode_Buku, pk.IdPetugas, p.Nama, pk.Tgl_Pinjam, pk.Tgl_Kembali, pk.Denda
    FROM pengembalian pk
    JOIN anggota a ON pk.IdAnggota = a.IdAnggota
    JOIN petugas p ON pk.IdPetugas = p.IdPetugas
    WHERE pk.Tgl_Kembali = search_date;
END //

DELIMITER ;
SET @search_date = '2024-03-20';
CALL SearchPengembalianByDate(@search_date);

select * from pengembalian;

DELIMITER //

-- No 2
CREATE PROCEDURE GetAnggotaByStatusPinjam(INOUT status_ VARCHAR(150))
BEGIN
    SELECT * 
    FROM anggota
    WHERE Status_Pinjam = status_;
END //

DELIMITER ;
drop procedure getanggotabystatuspinjamout;

SET @status_ = 'Meminjam';
CALL GetAnggotaByStatusPinjam(@status_);


DELIMITER //

-- NO 3
CREATE PROCEDURE GetAnggotaByStatusPinjamOUT(IN status_ VARCHAR(150), OUT result_count INT)
BEGIN
    SELECT * 
    FROM anggota
    WHERE Status_Pinjam = status_;
    
    SELECT COUNT(*) INTO result_count 
    FROM anggota
    WHERE Status_Pinjam = status_;
END //

DELIMITER ;


CALL GetAnggotaByStatusPinjamOUT('Meminjam', @result_count);
SELECT @result_count;


DELIMITER //

-- N0 4
CREATE PROCEDURE AddNewBuku(
    IN Kode_Buku VARCHAR(100),
    IN Judul_Buku VARCHAR(100),
    IN Pengarang_Buku VARCHAR(100),
    IN Penerbit_Buku VARCHAR(100),
    IN Tahun_Buku VARCHAR(100),
    IN Jumlah_Buku VARCHAR(100),
    IN Status_Buku VARCHAR(100),
    IN Klasifikasi_Buku VARCHAR(200)
)
BEGIN
    INSERT INTO buku (Kode_Buku, Judul_Buku, Pengarang_Buku, Penerbit_Buku, Tahun_Buku, Jumlah_Buku, Status_Buku, Klasifikasi_Buku)
    VALUES (Kode_Buku, Judul_Buku, Pengarang_Buku, Penerbit_Buku, Tahun_Buku, Jumlah_Buku, Status_Buku, Klasifikasi_Buku);

    SELECT 'Data buku telah berhasil ditambahkan' AS message;
END //

DELIMITER ;


CALL AddNewBuku('B018', 'Fisika', 'Susanti', 'Gramedia', '2024', '13', 'Tersedia', 'Pendidikan');
select * from buku;



DELIMITER //

-- No 5
CREATE PROCEDURE HapusAnggotaPerpus(
    IN p_anggota_id VARCHAR(10)
)
BEGIN
    DECLARE jumlah_pinjaman INT;
    DECLARE result VARCHAR(100);

    SELECT COUNT(*) INTO jumlah_pinjaman
    FROM anggota
    WHERE IdAnggota = p_anggota_id AND status_pinjam = 'meminjam';

    IF jumlah_pinjaman > 0 THEN
        SET result = 'Tidak dapat menghapus anggota karena masih memiliki pinjaman yang belum dikembalikan.';
    ELSE
        DELETE FROM anggota WHERE IdAnggota = p_anggota_id;
        SET result = 'Data anggota berhasil dihapus.';
    END IF;
    SELECT result;
END //

DELIMITER ;

drop procedure hapusanggotaperpus;

CALL HapusAnggotaPerpus('A001');
select * from anggota;
-- NO 6

-- Inner Join
CREATE VIEW ViewInnerJoin AS
SELECT a.IdAnggota, a.Nama_Anggota, COUNT(pem.Kode_Peminjaman) AS Total_Pinjaman
FROM anggota a
INNER JOIN peminjaman pem ON a.IdAnggota = pem.IdAnggota
GROUP BY a.IdAnggota, a.Nama_Anggota;

SELECT * FROM ViewInnerJoin;

-- Right Join
CREATE VIEW ViewRightJoin AS
SELECT a.IdAnggota, a.Nama_Anggota, COUNT(pem.Kode_Peminjaman) AS Total_Pinjaman
FROM anggota a
RIGHT JOIN peminjaman pem ON a.IdAnggota = pem.IdAnggota
GROUP BY a.IdAnggota , a.Nama_Anggota;

Drop view ViewRightJoin;
SELECT * FROM ViewRightJoin;

-- Left Join
CREATE VIEW ViewLeftJoin AS
SELECT a.IdAnggota, a.Nama_Anggota, COUNT(pem.Kode_Peminjaman) AS Total_Pinjaman
FROM anggota a
LEFT JOIN peminjaman pem ON a.IdAnggota = pem.IdAnggota
GROUP BY a.IdAnggota, a.Nama_Anggota;

SELECT * FROM ViewLeftJoin;