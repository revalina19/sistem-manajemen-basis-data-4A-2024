

CREATE TRIGGER `before_peminjaman_update` BEFORE UPDATE ON `peminjaman` FOR EACH ROW
BEGIN
     declare VarTotalHari int;
     declare VarTotalBayar DECIMAL;
     declare VarHargaPinjam DECIMAL;
     
    SELECT harga_sewa_perhari into VarHargaPinjam from peminjaman
    join mobil on mobil.id_mobil = peminjaman.id_mobil;
    

     IF NEW.tgl_kembali >= OLD.tgl_pinjam THEN
        set VarTotalHari = TIMESTAMPDIFF(DAY, NEW.tgl_kembali, OLD.tgl_pinjam)
        set VarTotalBayar = VarHargaPinjam * VarTotalHari;

        set NEW.total_bayar = VarTotalBayar;
        set NEW.total_hari = VarTotalHari;
     ELSE
        SIGNAL SQLSTATE '45000' set message_text = 'Ngawur wi inputan tanggal kembali ne e';
     END IF;
     
END;

CREATE procedure CatatPeminjaman (
    in Input_Id_Mobil int,
    in Input_Id_Pelanggan int,
    in Input_Tanggal_Pinjam Date,
    in input_Tanggal_Rencana_Kembali Date

)
begin 
    insert into peminjaman (id_mobil, id_peminjaman, tgl_pinjam, tgl_rencana_kembali) VALUES (
        Input_Id_Mobil, Input_Id_Pelanggan, Input_Tanggal_Pinjam, input_Tanggal_Rencana_Kembali
    );
END;

create procedure CataMobilKembali(
    in input_id_peminjaman int,
    in Input_tanggal_kembali date
)
begin 
    
    UPDATE `peminjaman` SET
      `tgl_kembali` = Input_tanggal_kembali,
    WHERE `id_peminjaman` = Input_Id_Pelanggan;
end;

---- 2


CREATE TRIGGER `before_pelanggan_insert` before INSERT ON `pelanggan` FOR EACH ROW
BEGIN
    
    IF LENGHT(NEW.nik) != 16 THEN
        SIGNAL SQLSTATE '45000' set message_text = 'Ngawur wi inputan NIK e';
    END IF;
    
END;



CREATE PROCEDURE `Tambah_Pelanggan`(
    in Input_Id_Pelanggan int,
    in Input_Nama varchar(100),
    in Input_Alamat varchar(100),
    in Input_NIK varchar(20),
    in Input_Jenis_kelamin varchar(1)
) BEGIN
   INSERT into pelanggan values (
        Input_Id_Pelanggan,
        Input_Nama,
        Input_Alamat,
        Input_NIK,
        Input_Jenis_kelamin
   );
END;


--- 3


CREATE TRIGGER `before_mobil_input` BEFORE INSERT ON `mobil` FOR EACH ROW
BEGIN
     
     IF NOT(SUBSTRING(NEW.plat_no, 1, 1) REGEXP '[A-Za-z]' OR SUBSTRING(NEW.plat_no, 2, 2) REGEXP '[A-Za-z]') THEN
        SIGNAL SQLSTATE '45000' set message_text = 'Ngawur wi inputan Plat Mu ii';
     END IF;
     
END;

CREATE PROCEDURE TambahMobil(
    IN Var_id_mobil int,
    IN Var_plat_no VARCHAR(15),
    IN Var_merk VARCHAR(50),
    IN Var_jenis VARCHAR(50),
    IN Var_harga_sewa_perhari DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Mobil VALUES
    (Var_id_mobil, Var_plat_no, Var_merk, Var_jenis, Var_harga_sewa_perhari);
END;



    