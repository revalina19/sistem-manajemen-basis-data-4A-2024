

CREATE procedure dataAnggotaPinjamBuku(IN totalBuku int) 
BEGIN
    SELECT A.nama_anggota, COUNT(*) AS jumlah_pinjam
    FROM tb_anggota A
    JOIN tb_peminjaman P ON A.id_anggota = P.id_anggota
    GROUP BY A.nama_anggota
    HAVING COUNT(*) > totalBuku;
END 

call dataAnggotaPinjamBuku (5);

--<<
create procedure cariStatusBuku(IN judulBuku varchar(50))
BEGIN
    SELECT judul Judul_Buku, status 
    FROM tb_buku
    WHERE judul = judulBuku;
END

call cariStatusBuku('Kisah Petualangan');

--<<
create procedure cariStatusPinjamAnggota(
    IN TahunAngkatan int(4),
    IN Gender char(1)
)
BEGIN
    SELECT nama_anggota, angkatan Tahun_Angkatan, status_pinjam
    FROM tb_anggota
    WHERE angkatan = TahunAngkatan and jenis_kelamin = Gender;
END

call cariStatusPinjamAnggota(2019, 'P')

--<<
create procedure cariAnggotaDenganStatus(
    IN TahunAngkatan int(4),
    IN Gender char(1),
    IN StatusPinjam varchar(20)
)
BEGIN
    SELECT nama_anggota, angkatan Tahun_Angkatan, status_pinjam
    FROM tb_anggota
    WHERE angkatan = TahunAngkatan and jenis_kelamin = Gender and status_pinjam = StatusPinjam;
END

call cariAnggotaDenganStatus(2019, 'p', 'Meminjam')

--<<
create procedure ubahStatusAnggota(
    IN StatusPeminjamanSekarang varchar(20),
    IN NamaAnggota varchar(50),
    IN UbahStatus varchar(20)
)
BEGIN
    --kondisi
    -- Declare statusSekarang varchar(20);
    -- if StatusPeminjamanSekarang == 1 then
    --     set statusSekarang = 'Meminjam';
    -- else 
    --     SET statusSekarang = 'Tidak Meminjam';
    -- END IF;

    -- Declare statusUbah varchar(20);
    -- if UbahStatusKe == 1 then
    --     set statusUbah = 'Meminjam';
    -- else 
    --     SET statusUbah = 'Tidak Meminjam';
    -- END IF;


    update tb_anggota
    SET status_pinjam = UbahStatus
    WHERE status_pinjam = StatusPeminjamanSekarang and nama_anggota = NamaAnggota;
END

call ubahStatusAnggota('Tidak Meminjam', 'Andi Setiawan', 'Meminjam')

--<<

create procedure jumlahAnggotaSekarang(Out Jumlah_Anggota int(10))
BEGIN
    SELECT COUNT(*) INTO Jumlah_Anggota FROM tb_anggota;
END

call jumlahAnggotaSekarang(@Jumlah_Anggota);
SELECT @Jumlah_Anggota;


create procedure Transaksi (
    in namaBarang varchar (50),
    in jumlah int(10),
    out DataTransaksi varchar(50)
)
BEGIN
    insert into transaksi (nama_barang, qty, tgl_barang_datang)
    values(namaBarang, jumlah, now());

    Declare DaftarBarang int(10);

    SELECT count(*)  into DaftarBarang
    FROM transaksi;

    DataTransaksi = DaftarBarang;
end

--<<

CREATE procedure DaftarKenaDenda (
    IN TotalDenda int(20),
    Out DataAnggotaDenda varchar(50)
)
BEGIN
    Declare totalAnggota int(10);

    SELECT count(*) into totalAnggota
    FROM tb_pengembalian
    WHERE denda >= TotalDenda;

    SET DataAnggotaDenda = totalAnggota;

    SELECT *
    FROM tb_anggota
    WHERE id_anggota IN (
        SELECT id_anggota
        FROM tb_pengembalian
        WHERE denda > TotalDenda 
    );
end

SET @TDenda='2000'; SET @tAgt=''; 
CALL DaftarKenaDenda(@TDenda, @tAgt); 
SELECT @tAgt AS DataAnggotaDenda;