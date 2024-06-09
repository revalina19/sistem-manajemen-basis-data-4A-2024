CREATE DATABASE db_sewa_mobil;
USE db_sewa_mobil;

CREATE TABLE Mobil (
    id_mobil INT PRIMARY KEY,
    plat_no VARCHAR(15) NOT NULL,
    merk VARCHAR(50) NOT NULL,
    jenis VARCHAR(50) NOT NULL,
    harga_sewa_perhari DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Pelanggan (
    id_pelanggan INT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    nik VARCHAR(20) NOT NULL,
    no_telepon VARCHAR(15) NOT NULL,
    jenis_kelamin VARCHAR(1) NOT NULL
);

CREATE TABLE Peminjaman (
    id_peminjaman INT PRIMARY KEY,
    id_mobil INT,
    id_pelanggan INT,
    tgl_pinjam DATE NOT NULL,
    tgl_rencana_kembali DATE NOT NULL,
    total_hari INT NOT NULL,
    total_bayar DECIMAL(10, 2) NOT NULL,
    tgl_kembali DATE,
    denda DECIMAL(10, 2),
    FOREIGN KEY (id_mobil) REFERENCES Mobil(id_mobil),
    FOREIGN KEY (id_pelanggan) REFERENCES Pelanggan(id_pelanggan)
);

INSERT INTO Mobil (id_mobil, plat_no, merk, jenis, harga_sewa_perhari) VALUES
(1, 'B1234XYZ', 'Toyota', 'Sedan', 500000.00),
(2, 'B5678ABC', 'Honda', 'SUV', 750000.00),
(3, 'B9101DEF', 'Suzuki', 'Hatchback', 400000.00),
(4, 'B1121GHI', 'Mitsubishi', 'Minivan', 600000.00),
(5, 'B3141JKL', 'Ford', 'Pickup', 800000.00);

INSERT INTO Pelanggan (id_pelanggan, nama, alamat, nik, no_telepon, jenis_kelamin) VALUES
(1, 'Andi Setiawan', 'Jl. Merdeka No. 1', '1234567890123456', '08123456789', 'L'),
(2, 'Budi Santoso', 'Jl. Sudirman No. 2', '2345678901234567', '08234567890', 'L'),
(3, 'Citra Dewi', 'Jl. Thamrin No. 3', '3456789012345678', '08345678901', 'P'),
(4, 'Dian Anggraini', 'Jl. Gatot Subroto No. 4', '4567890123456789', '08456789012', 'P'),
(5, 'Eko Saputra', 'Jl. M.H. Thamrin No. 5', '5678901234567890', '08567890123', 'L');

INSERT INTO Peminjaman (id_peminjaman, id_mobil, id_pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda) VALUES
(1, 1, 1, '2024-05-01', '2024-05-05', 4, 2000000.00, '2024-05-05', 0.00),
(2, 2, 2, '2024-05-03', '2024-05-07', 4, 3000000.00, '2024-05-07', 0.00),
(3, 3, 3, '2024-05-05', '2024-05-10', 5, 2000000.00, '2024-05-10', 0.00),
(4, 4, 4, '2024-05-07', '2024-05-12', 5, 3000000.00, '2024-05-12', 0.00),
(5, 5, 5, '2024-05-09', '2024-05-14', 5, 4000000.00, '2024-05-14', 0.00);

-- 1.
DELIMITER //
CREATE TRIGGER Validasi_Rencana_kembali
BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN 
	IF NEW.tgl_rencana_kembali < NEW.tgl_pinjam THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Tanggal rencana kembali tidak boleh awal dari tanggal pinjam.';
	END IF;
END //
DELIMITER;

drop trigger Validasi_rencana_kembali;

INSERT INTO peminjaman VALUES (6, 1, 1, CURDATE(), '2024-05-25', 5, 4000000.00, '2024-05-25', 0.00);

-- 2. 
DELIMITER //
CREATE TRIGGER perhitungan_Total_Bayar
BEFORE UPDATE ON peminjaman
FOR EACH ROW
BEGIN
	IF NEW.tgl_kembali IS NOT NULL THEN
		SET NEW.total_hari = DATEDIFF(NEW.tgl_kembali, NEW.tgl_pinjam);
		
		SET NEW.denda = CASE
				WHEN DATEDIFF(NEW.tgl_kembali, NEW.tgl_rencana_kembali) > 0 THEN
					0.1 * (SELECT harga_sewa_perhari FROM mobil WHERE id_mobil = NEW.id_mobil) *
					(DATEDIFF(NEW.tgl_kembali, NEW.tgl_rencana_kembali))
				ELSE
					0
				END;
		SET NEW.total_bayar = 
			(DATEDIFF(NEW.tgl_kembali, NEW.tgl_pinjam)) *
			(SELECT harga_sewa_perhari FROM mobil WHERE id_mobil = NEW.id_mobil) + NEW.denda;	
	END IF;			 
END //
DELIMITER;

UPDATE peminjaman SET tgl_kembali = '2024-05-29' WHERE id_peminjaman = 5;

-- 3.
DELIMITER //
CREATE TRIGGER Validasi_Panjang_NIK
BEFORE INSERT ON Pelanggan
FOR EACH ROW
BEGIN`mobil`
	IF LENGTH(NEW.nik) != 16 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Panjang NIK harus 16 digit!.';
	END IF;
END //
DELIMITER ;

INSERT INTO Pelanggan value (6,'Andre Renaldo','JL. Imam Bonjol No. 7','12323','08123456666','L');

-- 4.
DELIMITER //
CREATE TRIGGER Validasi_Plat_No
BEFORE INSERT ON Mobil
FOR EACH ROW
BEGIN
	IF NOT (NEW.plat_no REGEXP '^[A-Z] {2}') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Dua karakter awal plat nomor harus berupa huruf';
	END IF;
END //
DELIMITER ;

INSERT INTO Mobil value (6,'6876FF','Toyota','SUV','600000');
