USE perpustakaanku;

-- Jawaban Soal 1
DELIMITER //

CREATE PROCEDURE tampilkanBiodataMahasiswa(
    IN nim BIGINT,
    IN nama VARCHAR(50),
    IN alamat VARCHAR(100),
    IN nomerTelpon BIGINT,
    IN jenisKelamin VARCHAR(1),
    IN hobi VARCHAR(50),
    IN tanggalLahir DATE
)
BEGIN
    DECLARE vNim BIGINT;
    DECLARE vNama VARCHAR(50);
    DECLARE vAlamat VARCHAR(100);
    DECLARE vNoTlp BIGINT;
    DECLARE vJenisKelamin VARCHAR(1);
    DECLARE vHobi VARCHAR(50);
    DECLARE vTanggalLahir DATE;
    DECLARE vUmur INT;

    SET vNim = nim;
    SET vNama = nama;
    SET vAlamat = alamat;
    SET vNoTlp = nomerTelpon;
    SET vJenisKelamin = jenisKelamin;
    SET vHobi = hobi;
    SET vTanggalLahir = tanggalLahir;
    SET vUmur = TIMESTAMPDIFF(YEAR, vTanggalLahir, CURDATE());

    SELECT 
        vNim AS Nim, 
        vNama AS Nama_Mahasiswa, 
        vAlamat AS Alamat, 
        vNoTlp AS Nomer_Telpon,
        vJenisKelamin AS Jenis_Kelamin, 
        vHobi AS Hobi, 
        vTanggalLahir AS Tgl_Lahir, 
        vUmur AS Umur;
END//

DELIMITER ;

CALL tampilkanBiodataMahasiswa(220067644312, 'Dimas Cukurukuk', 'Jalan Sepanjang', 8193210001, 'L', 'Makan Es', '2001-10-12');

-- Jawaban Soal 2
DELIMITER//
CREATE PROCEDURE Pengingat1(
	IN tanggalPinjam DATE
)
BEGIN
	DECLARE keterangan VARCHAR(100);
	DECLARE selisih INT;
	
	SET selisih = DATEDIFF(CURDATE(), tanggalPinjam);
	IF selisih <= 2 THEN 
		SET keterangan = "Silahkan pergunakan buku dengan baik";
	ELSEIF selisih <=3 THEN
		SET keterangan = "Ingat!, Waktu pinjam segera habis";
	ELSEIF selisih >=5 THEN
		SET keterangan = "Ingat!, Waktu pinjam segera habis, Hayoo Segera Dibalikin Wak";
	ELSE
		SET keterangan = 'Warning!!!, Denda Menanti Anda';
    END IF;
    
    SELECT keterangan AS Keterangan_Pengingat;
END//
DELIMITER//

CALL Pengingat1 ('2024-05-15');

DROP PROCEDURE Pengingat1

-- Alternatif Jawaban Nomer 2
DELIMITER//
CREATE PROCEDURE PengingatDenda(
	IN tanggalPinjam DATE
)
BEGIN
	DECLARE keterangan VARCHAR(100);
	DECLARE selisih INT;
	
	SET selisih = DATEDIFF(CURDATE(), tanggalPinjam);
	CASE 
	WHEN selisih <= 2 THEN 
		SET keterangan = "Silahkan pergunakan buku dengan baik";
	WHEN selisih BETWEEN 3 AND 5 THEN
		SET keterangan = "Ingat!, Waktu pinjam segera habis";
	WHEN selisih >= 6 THEN
		SET keterangan = 'Warning!!!, Denda Menanti Anda';
    END CASE;
    
    SELECT keterangan AS Keterangan_Pengingat;
END//
DELIMITER//

CALL PengingatDenda('2024-05-03');

-- Jawaban Soal 3
DELIMITER //

CREATE PROCEDURE CekBayarDendaMhs(IN id_mahasiswa VARCHAR(10))
BEGIN
    DECLARE banyaknya INT;
    DECLARE keterangan VARCHAR(100);

    SELECT COUNT(*) INTO banyaknya
    FROM pengembalaian
    WHERE id_anggota = id_mahasiswa AND denda != 'Rp.0';

    IF banyaknya > 0 THEN
        SELECT kode_kembali, kode_buku, tanggal_pinjam, tanggal_kembali, denda
        FROM pengembalaian
        WHERE id_anggota = id_mahasiswa AND denda != 'Rp.0';
    ELSE
        SET keterangan = 'Mahasiswa tidak memiliki tanggungan atau denda.';
    END IF;
	SELECT keterangan AS Keterangan_denda;
END//
DELIMITER//

DROP PROCEDURE CekBayarDendaMhs

CALL CekBayarDendaMhs('anggota003');

-- Jawaban Soal 4
DELIMITER //

CREATE PROCEDURE loopingData()
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE loan_id VARCHAR(10);
    DECLARE borrower_id VARCHAR(10);
    DECLARE staff_id VARCHAR(10);
    DECLARE borrow_date DATE;
    DECLARE return_date DATE;
    DECLARE book_code VARCHAR(10);
    
    -- Membuat cursor untuk mengambil data peminjaman
    DECLARE loan_cursor CURSOR FOR
        SELECT kode_pinjaman, id_anggota, id_petugas, tanggal_pinjam, tanggal_kembali, kode_buku
        FROM pinjaman;
    
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET counter = 11; -- Keluar dari loop saat data tidak ditemukan
    
    -- Buka cursor
    OPEN loan_cursor;
    
    -- Loop untuk mencetak data peminjaman 1 sampai 10
    loan_loop: LOOP
        FETCH loan_cursor INTO loan_id, borrower_id, staff_id, borrow_date, return_date, book_code;
        IF counter > 10 THEN
            LEAVE loan_loop; -- Keluar dari loop ketika sudah mencetak 10 data
        END IF;
        
        -- Cetak data peminjaman
        SELECT CONCAT('Kode Pinjaman: ', loan_id) AS 'Kode Pinjaman',
               CONCAT('ID Anggota: ', borrower_id) AS 'ID Anggota',
               CONCAT('ID Petugas: ', staff_id) AS 'ID Petugas',
               CONCAT('Tanggal Pinjam: ', borrow_date) AS 'Tanggal Pinjam',
               CONCAT('Tanggal Kembali: ', return_date) AS 'Tanggal Kembali',
               CONCAT('Kode Buku: ', book_code) AS 'Kode Buku';
        
        SET counter = counter + 1; -- Increment counter
    END LOOP;
    
    -- Tutup cursor
    CLOSE loan_cursor;
    
END //

DELIMITER ;

DROP PROCEDURE loopingData
CALL loopingData();

-- Jawaban Soal 5
DELIMITER //

CREATE PROCEDURE hapusAnggotaPriaSejati(IN anggota_id VARCHAR(10))
BEGIN
    DECLARE Kondisi INT;
    DECLARE kalaudiaPerempuan INT;
    DECLARE result VARCHAR(100);

    SELECT COUNT(*)
    INTO Kondisi
    FROM anggota
    WHERE id_anggota = anggota_id AND jenis_kelamin = 'laki-laki' AND status_pinjaman != 'Rp.0';

    SELECT COUNT(*)
    INTO kalaudiaPerempuan
    FROM anggota
    WHERE id_anggota = anggota_id AND jenis_kelamin = 'perempuan';

    IF Kondisi > 0 THEN
        SELECT 'Anggota memiliki pinjaman yang belum selesai. Tidak dapat menghapus.' AS result;
    
    ELSEIF kalaudiaPerempuan > 0 THEN
        SELECT 'Data anggota tersebut adalah perempuan. Coba hapus data lain' AS result;
    ELSE
        DELETE FROM anggota WHERE id_anggota = anggota_id;
        SET result = 'Data berhasil dihapus wak';
    END IF;

    SELECT result;
END //
DELIMITER//

CALL hapusAnggotaPriaSejati('anggota002');

INSERT INTO anggota VALUES 
('anggota001','Dian Mousepad Logitech','Surabaya','1999-01-08',09182223,'laki-laki','0');

DROP PROCEDURE hapusAnggotaPriaSejati

-- Tambahan
SELECT * FROM pengembalaian

UPDATE pengembalaian
SET denda = 'Rp.100.000'
WHERE id_anggota = 'anggota001';

UPDATE pengembalaian
SET denda = 'Rp.0'
WHERE id_anggota = 'anggota001';