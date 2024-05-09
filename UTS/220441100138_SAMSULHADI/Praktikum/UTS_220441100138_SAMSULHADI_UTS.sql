--UPDATED
CREATE DATABASE IF NOT EXISTS toko_buku;

USE toko_buku;

CREATE TABLE Penulis (
    id_penulis INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255),
    negara VARCHAR(255)
);

CREATE TABLE Buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255),
    id_penulis INT,
    harga INT,
    stok INT,
    FOREIGN KEY (id_penulis) REFERENCES Penulis(id_penulis)
);

CREATE TABLE Penjualan (
    id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    id_buku INT,
    tanggal DATE,
    jumlah INT,
    FOREIGN KEY (id_buku) REFERENCES Buku(id_buku)
);


INSERT INTO Penulis (nama, negara) VALUES
('fulan', 'jateng');


INSERT INTO Buku (judul, id_penulis, harga, stok) VALUES
('Harry Potter', 1, 10000, 50),;
SELECT*FROM Buku;


-- VIEW BUKU PENULIS
CREATE VIEW viewBukuPenulis AS
SELECT Buku.judul AS judul_buku, Buku.harga, Buku.stok, Penulis.nama AS nama_penulis, Penulis.negara AS negara_penulis
FROM Buku
INNER JOIN Penulis ON Buku.id_penulis = Penulis.id_penulis;

SELECT*FROM viewBukuPenulis;

-- SELECT 5 DATA PERTAMA DARI HARGA TERMURAH KE TERMAHAL
SELECT * FROM viewBukuPenulis ORDER BY harga ASC LIMIT 5;

--TAMBAH PENJUALAN
DELIMITER //
CREATE PROCEDURE tambahPenjualan(IN buku_id INT, IN tanggal_penjualan DATE, IN jumlah_penjualan INT, OUT hasil VARCHAR(255))
BEGIN
    DECLARE stok_buku INT;
    SELECT stok INTO stok_buku FROM Buku WHERE id_buku = buku_id;

    IF stok_buku >= jumlah_penjualan THEN
        INSERT INTO Penjualan (id_buku, tanggal, jumlah) VALUES (buku_id, tanggal_penjualan, jumlah_penjualan);
        SET hasil = 'Penjualan Berhasil ditambahkan';
    ELSE
        SET hasil = 'Id Buku Tidak Tersedia. Penjualan gagal dilakukan!';
    END IF;
END //
DELIMITER ;

CALL tambahPenjualan(1, '2024-05-10', 10, @hasil);
SELECT @hasil;

CALL tambahPenjualan(999, '2024-05-10', 10, @hasil);
SELECT @hasil;

-- VIEW PENJUALAN TERBANYAK
CREATE VIEW penjualanTerbanyak AS
SELECT Buku.judul AS judul_buku, Penulis.nama AS nama_penulis, SUM(Penjualan.jumlah) AS total_penjualan
FROM Buku
INNER JOIN Penulis ON Buku.id_penulis = Penulis.id_penulis
INNER JOIN Penjualan ON Buku.id_buku = Penjualan.id_buku
GROUP BY Buku.id_buku
ORDER BY total_penjualan DESC
LIMIT 5;

SELECT*FROM penjualanTerbanyak;

-- STORED PROCEDURE MENAMBAHKAN BUKU
DELIMITER //

CREATE PROCEDURE insertToBuku(
    IN judul_buku VARCHAR(255),
    IN id_penulis INT,
    IN harga INT,
    IN stok INT,
    OUT hasil VARCHAR(255)
)
BEGIN
    DECLARE buku_count INT;
    
    SELECT COUNT(*) INTO buku_count FROM Buku WHERE judul = judul_buku;
    
    IF buku_count = 0 THEN
        INSERT INTO Buku (judul, id_penulis, harga, stok) VALUES (judul_buku, id_penulis, harga, stok);
        SET hasil = 'Buku berhasil ditambahkan ke dalam sistem';
    ELSE
        SET hasil = 'Buku sudah ada dalam database. Penambahan gagal dilakukan!';
    END IF;
END //

DELIMITER ;

CALL insertToBuku('Tere Liye', 1, 50000, 50, @hasil);
SELECT @hasil;
SELECT*FROM Buku;