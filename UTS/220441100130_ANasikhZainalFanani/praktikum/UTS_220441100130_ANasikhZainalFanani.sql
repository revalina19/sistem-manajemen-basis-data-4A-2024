CREATE DATABASE IF NOT EXISTS toko_buku;

USE toko_buku;

CREATE TABLE IF NOT EXISTS Penulis (
    id_penulis INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255),
    negara VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255),
    id_penulis INT,
    harga INT,
    stok INT,
    FOREIGN KEY (id_penulis) REFERENCES Penulis(id_penulis)
);

CREATE TABLE IF NOT EXISTS Penjualan (
    id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    id_buku INT,
    tanggal DATE,
    jumlah INT,
    FOREIGN KEY (id_buku) REFERENCES Buku(id_buku)
);


INSERT INTO Penulis (nama, negara) VALUES
('Haruki Murakami', 'Jepang'),
('J.K. Rowling', 'Inggris'),
('Agatha Christie', 'Inggris'),
('Stephen King', 'Amerika'),
('George Orwell', 'Inggris');

INSERT INTO Buku (judul, id_penulis, harga, stok) VALUES
('Norwegian Wood', 1, 150000, 100),
('1Q84', 1, 200000, 75),
('Harry Potter and the Philosopher''s Stone', 2, 180000, 120),
('Murder on the Orient Express', 3, 160000, 90),
('The Shining', 4, 170000, 80),
('1984', 5, 140000, 110);


CREATE VIEW viewBukuPenulis AS
SELECT B.judul AS judul_buku, B.harga, B.stok, P.nama AS nama_penulis, P.negara AS negara_penulis
FROM Buku AS B
JOIN Penulis AS P ON B.id_penulis = P.id_penulis;

SELECT *
FROM viewBukuPenulis
ORDER BY harga ASC
LIMIT 5;


DELIMITER //
	CREATE PROCEDURE tambahPenjualan(IN book_id INT, IN sale_date DATE, IN sale_amount INT, OUT result VARCHAR(255))
	BEGIN
	    DECLARE book_stok INT;
	    
	    SELECT stok INTO book_stok FROM Buku WHERE id_buku = book_id;
	    
	    IF book_stok >= sale_amount THEN
		INSERT INTO Penjualan (id_buku, tanggal, jumlah) VALUES (book_id, sale_date, sale_amount);
		SET result = 'Penjualan/Alert berhasil ditambahkan';
	    ELSE
		SET result = 'Id Buku Tidak Tersedia. Penjualan gagal dilakukan!';
	    END IF;
	    
	END//
DELIMITER ;
CALL tambahPenjualan(1, '2024-05-07', 15, @result);
SELECT @result;


CREATE VIEW penjualanTerbanyak AS
SELECT B.judul AS judul_buku, P.nama AS nama_penulis, SUM(J.jumlah) AS total_penjualan
FROM Penjualan AS J
JOIN Buku AS B ON J.id_buku = B.id_buku
JOIN Penulis AS P ON B.id_penulis = P.id_penulis
GROUP BY J.id_buku
ORDER BY total_penjualan DESC
LIMIT 5;


DELIMITER //
	CREATE PROCEDURE insertToBuku(IN book_title VARCHAR(255), IN author_id INT, IN book_price INT, IN book_stock INT, OUT result VARCHAR(255))
	BEGIN
	    DECLARE book_count INT;
	    
	    SELECT COUNT(*) INTO book_count FROM Buku WHERE judul = book_title AND id_penulis = author_id;
	    
	    IF book_count = 0 THEN
		INSERT INTO Buku (judul, id_penulis, harga, stok) VALUES (book_title, author_id, book_price, book_stock);
		SET result = 'Buku berhasil ditambahkan ke dalam sistem.';
	    ELSE
		SET result = 'Buku sudah ada dalam database.';
	    END IF;
	    
	END//
DELIMITER ;
CALL insertToBuku('Norwegian Wood', 1, 200000, 50, @result);
SELECT @result;
