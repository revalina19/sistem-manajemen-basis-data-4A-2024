CREATE TABLE tb_mahasiswa (
    nim INT PRIMARY KEY,
    nama_mahasiswa VARCHAR(50),
    alamat TEXT,
    no_telp VARCHAR(15),
    jenis_kelamin CHAR(1),
    hobi VARCHAR(100),
    tanggal_lahir DATE
);


CREATE procedure Data_Mahasiswa (
    IN input_NIM INT
)
BEGIN 
    Declare VNama varchar(255);
    Declare VAlamat TEXT;
    Declare VNoTlp varchar(255);
    Declare VJenisKelamin char(1);
    Declare VHobi varchar(255);
    Declare VTglLahir DATE;
    Declare VUmur varchar(10);

    SELECT nama_mahasiswa, alamat, no_telp, jenis_kelamin, hobi, tanggal_lahir
    into VNama, VAlamat, VNoTlp, VJenisKelamin, VHobi, VTglLahir 
    from tb_mahasiswa
    WHERE nim = input_NIM;


    set VUmur = timestampdiff(YEAR, VTglLahir, curdate());

    SELECT input_NIM NIM, 
        VNama Nama_Mahasiswa, 
        VAlamat Alamat, 
        VNoTlp No_Telpon, 
        VJenisKelamin jenis_kelamin, 
        VHobi Hobi,
        VTglLahir tanggal_lahir,
        VUmur Umur_Sekarang;
end;

create procedure  pengingat_pengembalian(
    IN VIdBuku int,
    IN VIdAnggota int
)
BEGIN
    Declare VTglPengembalian DATE;
    Declare VHari int;
    Declare Keterangan varchar(50);

    SELECT tanggal_kembali into VTglPengembalian 
    from tb_peminjaman
    WHERE id_anggota = VIdAnggota AND kode_buku = VIdBuku;


    set VHari = TIMESTAMPDIFF(DAY, curdate(), VTglPengembalian);

    IF VHari > 6  then
        set Keterangan = "Silahkan Pergunakan Buku Dengan Baik";
    ELSEIF VHari > 3 OR VHari = 5 then
        set Keterangan = "Ingat! Waktu Pinjam Segera Habis";
    else 
        set Keterangan = "Segera Kembalikan Buku, atau Denda Menanti Anda";
    END IF;

    SELECT Keterangan;
end;




create procedure PeriksaDenda(
    IN VIdAnggota int

)
BEGIN
    Declare kodePembayaran varchar(20);
    Declare totalDenda int;
    Declare namaMahasiswa varchar(20);
    Declare hasil varchar(20);

    SELECT bayar_denda into kodePembayaran 
    from tb_pengembalian WHERE id_anggota = VIdAnggota;

    SELECT nama_anggota into namaMahasiswa 
    from tb_anggota where id_anggota = VIdAnggota;

    if kodePembayaran = 1 then
        SELECT denda into totalDenda from tb_pengembalian where id_anggota = VIdAnggota;
        set hasil = "Silahakan Bayar Denda Anda Sebesar : ";
        SELECT hasil, totalDenda; 
    else 
        set hasil = "Anda Tidak Memiliki Tanggungan Denda";
        SELECT hasil; 
    end if;
end;

create procedure  DataPeminjaman (in menampilkan_berapa_data int)
BEGIN
    Declare selesai int DEFAULT 0;
    Declare VNamaAnggota varchar(255);
    declare VJudulBuku varchar(255);
    Declare VTglKembali DATE;
    Declare VTglPinjam DATE;
    Declare jumlahPerulangan int DEFAULT 1;
    
    DECLARE peminjaman_cursor CURSOR FOR
    SELECT tb_anggota.nama_anggota , tb_buku.judul, tanggal_pinjam, tanggal_kembali
    FROM tb_peminjaman join tb_anggota on tb_anggota.id_anggota = tb_peminjaman.id_anggota 
    join tb_buku on tb_buku.kode_buku = tb_peminjaman.kode_buku;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET selesai = 1;

    open peminjaman_cursor;

    read_loop: loop
        fetch  peminjaman_cursor INTO VNamaAnggota, VJudulBuku, VTglPinjam, VTglKembali;

        if selesai then
            leave read_loop;
        end if;

        SELECT VNamaAnggota Nama_Anggota, VJudulBuku Judul_Buku, VTglPinjam tanggal_pinjam, VTglKembali tanggal_kembali;

        set jumlahPerulangan = jumlahPerulangan + 1;

        if (jumlahPerulangan >= menampilkan_berapa_data) then
            leave read_loop;
        end if;

    end loop;

    close peminjaman_cursor;
end;
    
-- revisi hapus semua laki laki
create procedure HapusAnggotaLakiLaki()
BEGIN
    declare selesai int default 0;
    declare VIdAnggotaLaki int;
    declare VStatusPinjam int;
    declare Keterangan varchar(100);
    declare VarNamaAnggota varchar(100);

    declare laki_cursor CURSOR for
    select id_anggota , status_pinjam, nama_anggota from tb_anggota
    where jenis_kelamin = 'L' and status_pinjam = 'Tidak Meminjam';

    declare continue HANDLER for not found set selesai = 1;

    open laki_cursor;

    read_loop: loop 
        fetch laki_cursor into VIdAnggotaLaki, VStatusPinjam, VarNamaAnggota;

    
        -- if (VStatusPinjam = "Meminjam") then
        --     set Keterangan = concat("Anggota " , VarNamaAnggota , " Masih Belum Mengembalikan Buku");
        --     select Keterangan;
        -- else
        --     delete from tb_anggota where id_anggota = VIdAnggotaLaki;
        --     set Keterangan = concat("Anggota " , VarNamaAnggota , " Berhasil Dihapus");
        --     select Keterangan;
        -- end if;

        if selesai then
            leave read_loop;
        end if;

        if VStatusPinjam = "Tidak Meminjam" then 
            delete from tb_anggota where id_anggota = VIdAnggotaLaki and status_pinjam = VStatusPinjam;
        end if;

    end loop;
    close laki_cursor;
end;
drop procedure HapusAnggotaLakiLaki;

