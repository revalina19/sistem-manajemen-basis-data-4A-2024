USE db_perpustakaan;
--updated
--SOAL 1
--View
CREATE view cariPengembalian AS
SELECT 
        p.Kode_Kembali, 
        a.Nama_Anggota, 
        b.Judul_Buku, 
        pt.Nama, 
        p.Tgl_Pinjam, 
        p.Tgl_Kembali, 
        p.Denda 
    FROM 
        pengembalian p
    JOIN 
        anggota a ON p.IdAnggota = a.IdAnggota
    JOIN 
        buku b ON p.Kode_Buku = b.Kode_Buku
    JOIN 
        petugas pt ON p.IdPetugas = pt.IdPetugas;
SELECT * FROM cariPengembalian WHERE Tgl_Kembali = '2024-04-14';
--Procedure
DELIMITER //
CREATE PROCEDURE soal1(
    IN TanggalInput DATE,
    OUT Hasil TEXT
)
BEGIN
    DECLARE total_records INT DEFAULT 0;

    SELECT COUNT(*) INTO total_records
    FROM cariPengembalian
    WHERE Tgl_Kembali = TanggalInput;

    IF total_records > 0 THEN
       SELECT 
            GROUP_CONCAT(
                CONCAT(
                    Kode_Kembali, ' | ',
                    Nama_Anggota, ' | ',
                    Judul_Buku, ' | ',
                    Nama, ' | ',
                    Tgl_Pinjam, ' | ',
                    Tgl_Kembali, ' | ',
                    Denda
                ) SEPARATOR '\n'
            ) INTO Hasil
        FROM cariPengembalian
        WHERE Tgl_Kembali = TanggalInput;
    ELSE
        SET Hasil = 'Tidak ada data';
    END IF;
END //
DELIMITER ;
CALL soal1('2024-04-14', @Hasil);
SELECT @Hasil;
SELECT * FROM pengembalian;
DROP PROCEDURE IF EXISTS soal1;


--SOAL 2
DELIMITER //
CREATE PROCEDURE soal2(
    IN StatusInput VARCHAR(255),
    OUT HasilAnggota TEXT
)
BEGIN
    DECLARE total_records INT DEFAULT 0;
    SELECT COUNT(*) INTO total_records
    FROM anggota
    WHERE Status_Pinjam = StatusInput;
    IF total_records > 0 THEN
        SELECT 
            GROUP_CONCAT(
                CONCAT(
                    IdAnggota, ' | ',
                    Nama_Anggota, ' | ',
                    Angkatan_Anggota, ' | ',
                    Tempat_Lahir_Anggota, ' | ',
                    Tanggal_Lahir_Anggota, ' | ',
                    No_Telp, ' | ',
                    Status_Pinjam
                ) SEPARATOR '\n'
            ) INTO HasilAnggota
        FROM anggota
        WHERE Status_Pinjam = StatusInput;
    ELSE
        SET HasilAnggota = 'Tidak ada data';
    END IF;
END //
DELIMITER ;
CALL soal2('Aktif', @HasilAnggota);
SELECT @HasilAnggota;
DROP PROCEDURE IF EXISTS soal2;
SELECT * FROM anggota;

--SOAL 3
DELIMITER //
CREATE PROCEDURE soal3(
    OUT HasilAnggota TEXT
)   
BEGIN
    DECLARE total_records INT DEFAULT 0;
    SELECT COUNT(*) INTO total_records
    FROM anggota
    WHERE Status_Pinjam = 'Aktif';
    IF total_records > 0 THEN
        SELECT 
            GROUP_CONCAT(
                CONCAT(
                    IdAnggota, ' | ',
                    Nama_Anggota, ' | ',
                    Angkatan_Anggota, ' | ',
                    Tempat_Lahir_Anggota, ' | ',
                    Tanggal_Lahir_Anggota, ' | ',
                    No_Telp, ' | ',
                    Status_Pinjam
                ) SEPARATOR '\n'
            ) INTO HasilAnggota
        FROM anggota
        WHERE Status_Pinjam = 'Aktif';
    ELSE
        SET HasilAnggota = 'Tidak ada data';
    END IF;
END //
DELIMITER ;
CALL soal3(@Hasil);
SELECT @Hasil;
DROP PROCEDURE IF EXISTS soal3;
SELECT * FROM anggota;


--SOAL 4
DELIMITER //
CREATE PROCEDURE soal4(
    IN KodeBuku VARCHAR(10),
    IN JudulBuku VARCHAR(25),
    IN PengarangBuku VARCHAR(30),
    IN PenerbitBuku VARCHAR(30),
    IN TahunBuku VARCHAR(10),
    IN JumlahBuku VARCHAR(5),
    IN StatusBuku VARCHAR(10),
    IN KlasifikasiBuku VARCHAR(20)
)
BEGIN
    INSERT INTO buku (
        Kode_Buku, 
        Judul_Buku, 
        Pengarang_Buku, 
        Penerbit_Buku, 
        Tahun_Buku, 
        Jumlah_Buku, 
        Status_Buku, 
        Klasifikasi_Buku
    ) 
    VALUES (
        KodeBuku, 
        JudulBuku, 
        PengarangBuku, 
        PenerbitBuku, 
        TahunBuku, 
        JumlahBuku, 
        StatusBuku, 
        KlasifikasiBuku
    );
    SELECT 'Data buku berhasil ditambahkan' AS PesanKonfirmasi;
END //
DELIMITER ;
CALL soal4('B007', 'Komik Naruto Chapter 201', 'agung', 'bukalapak', '2022', '40', 'Available', 'Action');
SELECT * FROM buku;

--SOAL 5
DELIMITER //
CREATE PROCEDURE soal5(
    IN IdAnggotaInput VARCHAR(10)
)
BEGIN
    DECLARE JmlPinjaman INT;

    SELECT COUNT(*) INTO JmlPinjaman
    FROM peminjaman 
    WHERE IdAnggota = IdAnggotaInput AND Tanggal_Kembali > CURDATE();

    IF JmlPinjaman > 0 THEN
        SELECT 'Tidak dapat menghapus anggota, masih memiliki pinjaman yang belum dikembalikan' AS PesanKesalahan;
    ELSE
        DELETE FROM anggota WHERE IdAnggota = IdAnggotaInput;
        SELECT 'Data anggota berhasil dihapus' AS PesanKonfirmasi;
    END IF;
END //
DELIMITER ;
START TRANSACTION;
CALL soal5('A002');
ROLLBACK;
DROP PROCEDURE IF EXISTS soal5;
select*from peminjaman;

--SOAL 6
--view Inner
CREATE VIEW viewInnerJoin AS
SELECT 
    a.IdAnggota,
    a.Nama_Anggota,
    COUNT(p.Kode_Peminjaman) AS TotalPinjaman
FROM 
    anggota a
INNER JOIN 
    peminjaman p ON a.IdAnggota = p.IdAnggota
GROUP BY 
    a.IdAnggota, a.Nama_Anggota;
SELECT * FROM viewInnerJoin;

--View Left
CREATE VIEW viewLeftJoin AS
SELECT 
    pt.IdPetugas,
    pt.Nama AS Nama_Petugas,
    COUNT(pj.Kode_Peminjaman) AS TotalPinjaman
FROM 
    petugas pt
LEFT JOIN 
    peminjaman pj ON pt.IdPetugas = pj.IdPetugas
GROUP BY 
    pt.IdPetugas, pt.Nama;
drop view if EXISTS viewLectJoin;
SELECT * FROM viewLeftJoin;

--View Right
CREATE VIEW viewRightJoin AS
SELECT 
    b.Kode_Buku,
    b.Judul_Buku,
    COUNT(pj.Kode_Peminjaman) AS TotalDipinjam
FROM 
    buku b
RIGHT JOIN 
    peminjaman pj ON b.Kode_Buku = pj.Kode_Buku
GROUP BY 
    b.Kode_Buku, b.Judul_Buku;

SELECT * FROM viewRightJoin;

