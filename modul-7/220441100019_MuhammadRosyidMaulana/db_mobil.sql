
CREATE TABLE Mobil (
    id_mobil INT PRIMARY KEY,
    plat_no VARCHAR(15),
    merk VARCHAR(50),
    jenis VARCHAR(50),
    harga_sewa_perhari DECIMAL(10, 2)
);
CREATE TABLE Pelanggan (
    id_pelanggan INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat VARCHAR(255),
    nik VARCHAR(20),
    no_telepon VARCHAR(15),
    jenis_kelamin VARCHAR(1)
);
CREATE TABLE Peminjaman (
    id_peminjaman INT PRIMARY KEY,
    id_mobil INT,
    id_pelanggan INT,
    tgl_pinjam DATE,
    tgl_rencana_kembali DATE,
    total_hari INT,
    total_bayar DECIMAL(10, 2),
    tgl_kembali DATE,
    denda DECIMAL(10, 2),
    FOREIGN KEY (id_mobil) REFERENCES Mobil(id_mobil),
    FOREIGN KEY (id_pelanggan) REFERENCES Pelanggan(id_pelanggan)
);


INSERT INTO Mobil VALUES
(1, 'RX 897 YT', 'Toyota', 'SUV', 500000.00),
(2, 'R 7045 PR', 'Honda', 'Sedan', 450000.00),
(3, 'LM 778 Y', 'Suzuki', 'Sedan', 400000.00),
(4, 'GT 32 R', 'Nissan', 'GT-R', 550000.00),
(5, 'BV 67 B', 'Mitsubishi', 'Sedan', 600000.00);

INSERT INTO Pelanggan VALUES
(1, 'Andi Pratama', 'MOJOKERTO', '3201234567890001', '081234567890', 'L'),
(2, 'Budi Santoso', 'SURABAYA', '3201234567890002', '081234567891', 'L'),
(3, 'Citra Dewi', 'SURABAYA' , '3201234567890003', '081234567892', 'P'),
(4, 'Dewi Lestari', 'GRESIK', '3201234567890004', '081234567893', 'P'),
(5, 'Eko Susilo', 'DARJO', '3201234567890005', '081234567894', 'L');

INSERT INTO Peminjaman VALUES
(1, 1, 1, '2024-05-01', '2024-05-05', 4, 2000000.00, '2024-05-05', 0.00),
(2, 2, 2, '2024-05-03', '2024-05-07', 4, 1800000.00, '2024-05-07', 0.00),
(3, 3, 3, '2024-05-04', '2024-05-08', 4, 1600000.00, '2024-05-08', 0.00),
(4, 4, 4, '2024-05-05', '2024-05-09', 4, 2200000.00, '2024-05-09', 0.00),
(5, 5, 5, '2024-05-06', '2024-05-10', 4, 2400000.00, '2024-05-10', 0.00);

