/Nomor 1/
DELIMITER //

CREATE PROCEDURE CariPengembalian(
    INOUT tanggal_kembali DATE
)
BEGIN
    SELECT 
        p.kode_kembali,
        a.nama_anggota,
        b.judul_buku,
        t.nama AS nama_petugas,
        p.tgl_pinjam,
        p.tgl_kembali,
        p.denda
    FROM 
        pengembalian p
    JOIN 
        anggota a ON p.id_anggota = a.id_anggota
    JOIN 
        buku b ON p.kode_buku = b.kode_buku
    JOIN 
        petugas t ON p.id_petugas = t.id_petugas
    WHERE 
        DATE(p.tgl_kembali) = tanggal_kembali;
END //

DELIMITER ;

SET @tanggal = '2024-05-28';
CALL CariPengembalian(@tanggal);

/Nomor 2/
DELIMITER //

CREATE PROCEDURE CariAnggotaBerdasarkanStatus(
    INOUT status_pinjam VARCHAR(15)
)
BEGIN
    SELECT 
        id_anggota,
        nama_anggota,
        tempat_lahir_anggota,
        tanggal_lahir_anggota,
        no_telp,
        jenis_kelamin,
        status_pinjam
    FROM 
        anggota
    WHERE 
        status_pinjam = status_pinjam;
END //

DELIMITER ;

SET @status = 'pinjam';
CALL CariAnggotaBerdasarkanStatus(@status);

/*Nomor 3*/
DELIMITER //
CREATE PROCEDURE daftarAnggota (
    OUT agt_count INT,
    IN statu VARCHAR(50)
)
BEGIN
    
    SELECT COUNT(*) INTO agt_count FROM anggota WHERE status_pinjam = statu;
    
    IF agt_count > 0 THEN
        SELECT * FROM anggota WHERE status_pinjam = statu;
    END IF;
    
END // 
DELIMITER ;

CALL daftarAnggota(@agt, 'kembali');

/Nomor 4/
DELIMITER //

CREATE PROCEDURE TambahBuku(
    IN p_kode_buku VARCHAR(10),
    IN p_judul_buku VARCHAR(25),
    IN p_pengarang_buku VARCHAR(30),
    IN p_tahun_buku VARCHAR(10),
    IN p_jumlah_buku VARCHAR(5)
)
BEGIN
    DECLARE keterangan VARCHAR(100);
    
    SELECT COUNT(*) INTO keterangan
    FROM buku 
    WHERE kode_buku = p_kode_buku;
    
    IF keterangan > 0 THEN
        SET keterangan = CONCAT('Data buku dengan kode ', p_kode_buku, ' sudah ada.');
    ELSE
        INSERT INTO buku (kode_buku, judul_buku, pengarang_buku, tahun_buku, jumlah_buku) 
        VALUES (p_kode_buku, p_judul_buku, p_pengarang_buku, p_tahun_buku, p_jumlah_buku);
        SET keterangan = CONCAT('Data buku dengan kode ', p_kode_buku, ' berhasil ditambahkan.');
    END IF;
    SELECT keterangan;
END //

DELIMITER ;

CALL TambahBuku('B011', 'masih pemula', 'saya', '2024', '100');
DELETE FROM buku WHERE kode_buku = 'B011';

/Nomor 5/
DELIMITER //

CREATE PROCEDURE HapusAnggota(
    IN p_anggota_id VARCHAR(10)
)
BEGIN
    DECLARE jumlah_pinjaman INT;
    DECLARE result VARCHAR(100);

    SELECT COUNT(*) INTO jumlah_pinjaman
    FROM anggota
    WHERE id_anggota = p_anggota_id AND status_pinjam = 'pinjam';

    IF jumlah_pinjaman > 0 THEN
        SET result = 'Tidak dapat menghapus anggota karena masih memiliki pinjaman yang belum dikembalikan.';
    ELSE
        DELETE FROM anggota WHERE id_anggota = p_anggota_id;
        SET result = 'Data anggota berhasil dihapus.';
    END IF;
    SELECT result;
END //

DELIMITER ;

CALL HapusAnggota('A010');

/*Nomor 6*/
CREATE TABLE anak(
    anak_id INT PRIMARY KEY,
    nama_anak VARCHAR(50),
    hp_id INT
);

CREATE TABLE hp (
    hp_id INT PRIMARY KEY,
    merk_hp VARCHAR(50)
);

INSERT INTO anak (anak_id, nama_anak, hp_id) VALUES
(1, 'Ahmad', 101),
(2, 'Budi', 102),
(3, 'Cinta', NULL),
(4, 'Dinda', NULL),
(5, 'Erika', 103);

INSERT INTO hp (hp_id, merk_hp) VALUES
(101, 'Samsung'),
(102, 'iPhone'),
(103, 'Xiaomi'),
(104, 'Oppo'),
(105, 'Vivo');

CREATE VIEW anak_hp_count AS
SELECT 
    anak.nama_anak, 
    hp.merk_hp, 
    COUNT(hp.merk_hp) AS jumlah_hp
FROM 
    anak
LEFT JOIN 
    hp ON anak.hp_id = hp.hp_id
GROUP BY 
    anak.nama_anak, hp.merk_hp;


CREATE VIEW hp_anak_count AS
SELECT 
    anak.nama_anak, 
    hp.merk_hp, 
    COUNT(anak.nama_anak) AS jumlah_anak
FROM 
    anak
RIGHT JOIN 
    hp ON anak.hp_id = hp.hp_id
GROUP BY 
    anak.nama_anak, hp.merk_hp;


CREATE VIEW anak_hp_inner AS
SELECT 
    anak.nama_anak, 
    hp.merk_hp, 
    COUNT(anak.nama_anak) AS jumlah_anak
FROM 
    anak
INNER JOIN 
    hp ON anak.hp_id = hp.hp_id
GROUP BY 
    anak.nama_anak, hp.merk_hp;
