
create TABLE stok_barang (
    id_stock varchar(5),
    nama_barang varchar(20),
    qty INTEGER(10),
    price NUMERIC, 
    PRIMARY KEY (id_stock)
    ); 

CREATE TABLE pelanggan(
    id_pelanggan int(5),
    tlp bigInt(20),
    nama_pelanggan VARCHAR(20),
    almt text,
    PRIMARY KEY (id_pelanggan)
);

CREATE TABLE supplier (
    id_supplier int(5),
    tlp bigInt(20),
    nama_supplier VARCHAR(10),
    almt text,
    PRIMARY KEY (id_supplier)
);

create TABLE penjualan (
    kode_penjualan VARCHAR(5),
    tgl_jual DATE,
    qty_jual int(5),
    total_harga NUMERIC,
    kode_pelanggan int(5),
    kode_barang VARCHAR(5),
    PRIMARY KEY (kode_penjualan),
    FOREIGN KEY (kode_pelanggan) REFERENCES pelanggan(id_pelanggan),
    FOREIGN KEY (kode_barang) REFERENCES stok_barang(id_stock)
);

create TABLE retur_customer (
    kode_retur_customer VARCHAR(5),
    tgl_rc DATE,
    qty_rc int(5),
    total_harga NUMERIC,
    kode_penjualan VARCHAR(5), 
    PRIMARY KEY (kode_retur_customer),
    FOREIGN KEY (kode_penjualan) REFERENCES penjualan (kode_penjualan)
);

CREATE TABLE pcs_suppplier (
    kode_pcs_supp VARCHAR(5),
    tgl_pcs_supp DATE,
    qty_pcs_supp int(5),
    total_harga NUMERIC,
    kode_supp int(5),
    PRIMARY KEY (kode_pcs_supp),
    FOREIGN KEY (kode_supp) REFERENCES supplier(id_supplier)
);

CREATE TABLE transaksi_penjualan (
    id_transaksi INT(5) PRIMARY KEY,
    tanggal DATE,
    id_pelanggan INT,
    total_penjualan NUMERIC,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

CREATE TABLE transaksi_pembelian (
    id_transaksi INT(5) PRIMARY KEY,
    tanggal DATE,
    id_supplier INT,
    total_pembelian NUMERIC,
    FOREIGN KEY (id_supplier) REFERENCES supplier (id_supplier)
);

INSERT INTO stok_barang (id_stock, nama_barang, qty, price) VALUES
('ST001', 'Beras', 100, 15000),
('ST002', 'Gula', 150, 12000),
('ST003', 'Minyak Goreng', 200, 20000),
('ST004', 'Mie Instan', 120, 3000),
('ST005', 'Sabun Mandi', 80, 5000),
('ST006', 'Shampoo', 90, 10000),
('ST007', 'Pasta Gigi', 70, 7000),
('ST008', 'Teh Celup', 110, 8000),
('ST009', 'Kopi Bubuk', 100, 12000),
('ST010', 'Susu Kental', 130, 10000);


INSERT INTO pelanggan (id_pelanggan, tlp, nama_pelanggan, almt) VALUES
(1001, 628123456789, 'Budi', 'Jl. Merdeka No. 10'),
(1002, 628987654321, 'Ani', 'Jl. Pahlawan No. 5'),
(1003, 628555666777, 'Citra', 'Jl. Raya No. 15'),
(1004, 628888999000, 'Dewi', 'Jl. Damai No. 25'),
(1005, 628333444555, 'Eka', 'Jl. Cendana No. 8'),
(1006, 628666777888, 'Fani', 'Jl. Mawar No. 12'),
(1007, 628222333444, 'Gita', 'Jl. Anggrek No. 7'),
(1008, 628777888999, 'Hadi', 'Jl. Mangga No. 3'),
(1009, 628444555666, 'Ira', 'Jl. Melati No. 6'),
(1010, 628999000111, 'Joni', 'Jl. Kenari No. 9');


INSERT INTO supplier (id_supplier, tlp, nama_supplier, almt) VALUES
(2001, 628111222333, 'SupplierA', 'Jl. Jenderal Sudirman No. 11'),
(2002, 628222333444, 'SupplierB', 'Jl. Gatot Subroto No. 22'),
(2003, 628333444555, 'SupplierC', 'Jl. Diponegoro No. 33'),
(2004, 628444555666, 'SupplierD', 'Jl. Ahmad Yani No. 44'),
(2005, 628555666777, 'SupplierE', 'Jl. Gajah Mada No. 55'),
(2006, 628666777888, 'SupplierF', 'Jl. Hayam Wuruk No. 66'),
(2007, 628777888999, 'SupplierG', 'Jl. Sisingamangaraja No. 77'),
(2008, 628888999000, 'SupplierH', 'Jl. Sudirman No. 88'),
(2009, 628999000111, 'SupplierI', 'Jl. Thamrin No. 99'),
(2010, 628000111222, 'SupplierJ', 'Jl. Haji Agus Salim No. 100');


INSERT INTO penjualan (kode_penjualan, tgl_jual, qty_jual, total_harga, kode_pelanggan, kode_barang) VALUES
('PJ001', '2024-04-01', 10, 150000, 1001, 'ST001'),
('PJ002', '2024-04-02', 15, 180000, 1002, 'ST002'),
('PJ003', '2024-04-03', 20, 400000, 1003, 'ST003'),
('PJ004', '2024-04-04', 12, 36000, 1004, 'ST004'),
('PJ005', '2024-04-05', 8, 40000, 1005, 'ST005'),
('PJ006', '2024-04-06', 9, 90000, 1006, 'ST006'),
('PJ007', '2024-04-07', 7, 49000, 1007, 'ST007'),
('PJ008', '2024-04-08', 11, 88000, 1008, 'ST008'),
('PJ009', '2024-04-09', 10, 120000, 1009, 'ST009'),
('PJ010', '2024-04-10', 13, 130000, 1010, 'ST010');


INSERT INTO retur_customer (kode_retur_customer, tgl_rc, qty_rc, total_harga, kode_penjualan) VALUES
('RC001', '2024-04-02', 2, 30000, 'PJ001'),
('RC002', '2024-04-05', 1, 12000, 'PJ002'),
('RC003', '2024-04-08', 3, 60000, 'PJ003'),
('RC004', '2024-04-10', 2, 6000, 'PJ004'),
('RC005', '2024-04-15', 1, 5000, 'PJ005'),
('RC006', '2024-04-18', 1, 10000, 'PJ006'),
('RC007', '2024-04-20', 1, 7000, 'PJ007'),
('RC008', '2024-04-25', 2, 16000, 'PJ008'),
('RC009', '2024-04-28', 1, 20000, 'PJ009'),
('RC010', '2024-04-30', 3, 39000, 'PJ010');


INSERT INTO pcs_suppplier (kode_pcs_supp, tgl_pcs_supp, qty_pcs_supp, total_harga, kode_supp) VALUES
('PCS001', '2024-04-05', 20, 200000, 2001),
('PCS002', '2024-04-10', 25, 250000, 2002),
('PCS003', '2024-04-15', 30, 300000, 2003),
('PCS004', '2024-04-20', 35, 350000, 2004),
('PCS005', '2024-04-25', 40, 400000, 2005),
('PCS006', '2024-04-26', 45, 450000, 2006),
('PCS007', '2024-04-28', 50, 500000, 2007),
('PCS008', '2024-04-29', 55, 550000, 2008),
('PCS009', '2024-04-30', 60, 600000, 2009),
('PCS010', '2024-04-01', 65, 650000, 2010);


INSERT INTO transaksi_penjualan (id_transaksi, tanggal, id_pelanggan, total_penjualan) VALUES
(1, '2024-04-01', 1001, 150000),
(2, '2024-04-02', 1002, 180000),
(3, '2024-04-03', 1003, 400000),
(4, '2024-04-04', 1004, 36000),
(5, '2024-04-05', 1005, 40000),
(6, '2024-04-06', 1006, 90000),
(7, '2024-04-07', 1007, 49000),
(8, '2024-04-08', 1008, 88000),
(9, '2024-04-09', 1009, 120000),
(10, '2024-04-10', 1010, 130000);


INSERT INTO transaksi_pembelian (id_transaksi, tanggal, id_supplier, total_pembelian) VALUES
(1, '2024-04-05', 2001, 200000),
(2, '2024-04-10', 2002, 250000),
(3, '2024-04-15', 2003, 300000),
(4, '2024-04-20', 2004, 350000),
(5, '2024-04-25', 2005, 400000),
(6, '2024-04-26', 2006, 450000),
(7, '2024-04-28', 2007, 500000),
(8, '2024-04-29', 2008, 550000),
(9, '2024-04-30', 2009, 600000),
(10, '2024-04-01', 2010, 650000);


SELECT * FROM transaksi_pembelian;
SELECT * FROM transaksi_penjualan;
SELECT * FROM pcs_suppplier;
SELECT * FROM retur_customer;
SELECT * FROM penjualan;
SELECT * FROM supplier;
SELECT * FROM pelanggan;
SELECT * FROM stok_barang;






