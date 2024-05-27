CREATE procedure TampilDataPengembalian (
    in VTgl DATE,
    out dataPengembalian varchar(100)
)
BEGIN
    declare DataPetugas varchar(255);
    declare DataAnggota varchar(255);

    -- SELECT tb_petugas.usrname, tb_anggota.nama_anggota , tb_buku.judul,  tanggal_pinjam, tanggal_kembali
    -- FROM tb_pengembalian join tb_anggota on tb_anggota.id_anggota = tb_pengembalian.id_anggota 
    -- join tb_buku on tb_buku.kode_buku = tb_pengembalian.kode_buku
    -- join tb_petugas on tb_petugas.id_petugas = tb_pengembalian.id_petugas
    -- where tanggal_kembali = VTgl;
    
    SELECT tb_petugas.usrname into DataPetugas
    FROM tb_pengembalian 
    join tb_petugas on tb_petugas.id_petugas = tb_pengembalian.id_petugas
    where tanggal_kembali = VTgl;
    
    SELECT tb_anggota.nama_anggota into DataAnggota
    FROM tb_pengembalian join tb_anggota on tb_anggota.id_anggota = tb_pengembalian.id_anggota
    where tanggal_kembali = VTgl;

    SET dataPengembalian = CONCAT('Petugas: ', DataPetugas, ', Anggota: ', DataAnggota);

end;

create procedure TampilDataAnggotaByStatus (
    in VStatusPinjam varchar(100),
    out VTotalData int
)
begin 
    declare Total int;

    select * from tb_anggota WHERE status_pinjam = VStatusPinjam ;

    select count(*) into Total from tb_anggota 
    where status_pinjam = VStatusPinjam;

    set VTotalData = Total;
end;

-- 3

create procedure TambahDataBuku (
    in Vjudul varchar(100),
    in Vpengarang varchar(100),
    in Vpenerbit varchar(100),
    in Vtahun_terbit int,
    in Vstok int,
    in Vklasifikasi varchar(100)
)
begin
    declare Keterangan varchar(100);
    declare StatusStok varchar(10) DEFAULT 'Tersedia';

    insert into tb_buku VALUES (
        "", Vjudul, Vpengarang, Vpenerbit, 
        Vtahun_terbit, VStok, StatusStok, klasifikasi);

    set Keterangan = "Data Buku Telah Ditambahkan";
    SELECT Keterangan;

end;

create procedure HapusAnggotaById(
    in ID_MILIK_ANGGOTA int
)
BEGIN
    DECLARE Keterangan varchar(50);
    declare NamaAnggota varchar(50);
    declare StatusPeminjamanSekarang varchar(50);
    
    SELECT status_pinjam into StatusPeminjamanSekarang 
    from tb_anggota where id_anggota = ID_MILIK_ANGGOTA;

    SELECT nama_anggota into NamaAnggota from tb_anggota where id_anggota = ID_MILIK_ANGGOTA;

    if (StatusPeminjamanSekarang = "Meminjam") then
        set Keterangan = CONCAT('Tidak Berhasil Menghapus Data Anggota ' , NamaAnggota); 
        SELECT Keterangan;
    else 
        delete from tb_anggota where id_anggota = ID_MILIK_ANGGOTA;
        set Keterangan = CONCAT('Berhasil Menghapus Data Anggota ' , NamaAnggota);
        SELECT Keterangan;
    end if;
end;

-- revisi agregasi
CREATE VIEW DataPeminjamanLeftJoin AS
SELECT
    tb_anggota.id_anggota,
    tb_anggota.nama_anggota,
    COUNT(tb_buku.kode_buku)  jumlah_buku_dipinjam
FROM
    tb_peminjaman
LEFT JOIN tb_anggota ON tb_peminjaman.id_anggota = tb_anggota.id_anggota
LEFT JOIN tb_buku ON tb_peminjaman.kode_buku = tb_buku.kode_buku
GROUP BY
    tb_anggota.id_anggota,
    tb_anggota.nama_anggota
HAVING
    COUNT(tb_buku.kode_buku) > 1;

CREATE view DataPeminjamanRightJoin as
SELECT
    tb_anggota.id_anggota,
    tb_anggota.nama_anggota,
    COUNT(tb_buku.kode_buku)  jumlah_buku_dipinjam
FROM
    tb_peminjaman
RIGHT JOIN tb_anggota ON tb_peminjaman.id_anggota = tb_anggota.id_anggota
RIGHT JOIN tb_buku ON tb_peminjaman.kode_buku = tb_buku.kode_buku
GROUP BY
    tb_anggota.id_anggota,
    tb_anggota.nama_anggota
HAVING
    COUNT(tb_buku.kode_buku) > 1;


CREATE view DataPeminjamanInnerJoin as
SELECT
    tb_anggota.id_anggota,
    tb_anggota.nama_anggota,
    COUNT(tb_buku.kode_buku)  jumlah_buku_dipinjam
FROM
    tb_peminjaman
inner JOIN tb_anggota ON tb_peminjaman.id_anggota = tb_anggota.id_anggota
inner JOIN tb_buku ON tb_peminjaman.kode_buku = tb_buku.kode_buku
GROUP BY
    tb_anggota.id_anggota,
    tb_anggota.nama_anggota
HAVING
    COUNT(tb_buku.kode_buku) > 1;


