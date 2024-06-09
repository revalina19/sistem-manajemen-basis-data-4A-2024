CREATE VIEW view_anggota_meminjam_banyak AS SELECT A.nama_anggota, COUNT(*) AS jumlah_pinjam
FROM tb_anggota A
JOIN tb_peminjaman P ON A.id_anggota = P.id_anggota
GROUP BY A.nama_anggota
HAVING COUNT(*) > 5;

CREATE VIEW view_petugas_transaksi AS
SELECT p.id_petugas, p.nama_petugas, 
       COUNT(pj.kode_buku) AS jumlah_transaksi
FROM tb_petugas p
LEFT JOIN tb_peminjaman pj ON p.id_petugas = pj.id_petugas
LEFT JOIN tb_pengembalian pg ON p.id_petugas = pg.id_petugas
GROUP BY p.id_petugas;

CREATE VIEW view_petugas_terbanyak AS
SELECT id_petugas, nama_petugas, jumlah_transaksi
FROM view_petugas_transaksi
WHERE jumlah_transaksi = (
    SELECT MAX(jumlah_transaksi) FROM view_petugas_transaksi
);

CREATE VIEW view_buku_terpinjam AS
SELECT kode_buku, judul, COUNT(*) AS jumlah_peminjaman
FROM tb_peminjaman
JOIN tb_buku USING (kode_buku)
GROUP BY kode_buku
ORDER BY jumlah_peminjaman DESC
LIMIT 1;


-- Mengambil data dari view_anggota_meminjam_banyak
SELECT * FROM view_anggota_meminjam_banyak;

-- Mengambil data dari view_petugas_transaksi
SELECT * FROM view_petugas_transaksi;

-- Mengambil data dari view_petugas_terbanyak
SELECT * FROM view_petugas_terbanyak;

-- Mengambil data dari view_buku_terpinjam
SELECT * FROM view_buku_terpinjam;

