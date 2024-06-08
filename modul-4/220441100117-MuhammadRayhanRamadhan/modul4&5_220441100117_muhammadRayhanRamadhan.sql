-- Modul4 dan Modul5

-- Soal
Buat store PROCEDURE transaksi 
IN CREATE sebuah tabel
outnya menampilkan hasilnya

DELIMITER//
CREATE PROCEDURE getAnggota(
IN namaAnggota VARCHAR (20)
)
BEGIN
	SELECT nama_anggota FROM anggota WHERE nama_anggota = namaAnggota;
END//
DELIMITER//

CALL getAnggota('Heny');

CALL biodataMhs(22117,'Muhammad Rayhan Ramadhan','Jombang','L',098654322,20,'Basket Ball')
CALL pengembalianBuku('2024-05-06');
CALL denda_siswa(1);
CALL dataPeminjam(4);
CALL hapusAgt(1);


-- Modul 4&5
-- nomer1
DELIMITER //
CREATE PROCEDURE Pencarian(
    INOUT tglPinjam DATE
)
BEGIN 
    SELECT 
        kode_buku,id_anggota, id_petugas, nama_anggota, nama AS nama_petugas, tgl_pinjam, tgl_kembali
    FROM petugas NATURAL JOIN pengembalian NATURAL JOIN anggota
    WHERE 
        tgl_pinjam = tglPinjam;
END//
DELIMITER ;

SET @tglPinjam = '2022-10-05';
CALL Pencarian(@tglPinjam);


-- nomer2
DELIMITER //
CREATE PROCEDURE Statuspinjam(
    INOUT pinjam VARCHAR (20)
)
BEGIN 
 SELECT * FROM anggota
    WHERE 
        status_pinjam = pinjam;
        
END//
DELIMITER ;

SET @pinjam = 'meminjam';
CALL Statuspinjam(@pinjam);

-- nomer3
DELIMITER //
CREATE PROCEDURE DaftarAnggota(
    IN Statuss VARCHAR(20)
)
BEGIN 
    SELECT * FROM anggota
    WHERE 
        status_pinjam = Statuss;
END//
DELIMITER ;

SET @Statuss = 'meminjam';
CALL DaftarAnggota(@Statuss);


-- nomer4 
DELIMITER //
CREATE PROCEDURE tambah (
    IN KodeBuku INT(3),
    IN JudulBuku VARCHAR(30),
    IN PengarangBuku VARCHAR(30),
    IN TahunBuku INT(10),
    IN StatusBuku VARCHAR(10),
    IN Klasifikasi VARCHAR(10)
)
BEGIN
    DECLARE Informasi VARCHAR(100);
    DECLARE cacahBook INT;
    
    SELECT COUNT(*) INTO cacahBook
    FROM buku 
    WHERE kode_buku = KodeBuku;
    
    IF cacahBook > 0 THEN
    SET Informasi = CONCAT('Data Buku ', KodeBuku, ' Telah Tersedia');
    
    ELSE
    INSERT INTO buku (kode_buku, judul_buku, pengarang_buku, tahun_buku, status_buku, klasifikasi_buku)
    VALUES (KodeBuku, JudulBuku, PengarangBuku, TahunBuku, StatusBuku, Klasifikasi);
    SET Informasi = 'Data Buku Berhasil Ditambahkan';
    
    END IF;
    
    SELECT Informasi;

END//
DELIMITER ;

DROP PROCEDURE hapusData;
CALL tambah(7, 'Bumi', 'jojon', 2014, 'ready', 'Fantasi');


-- nomer5
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS hapusData (
    IN ururanAgt VARCHAR(10)
)
BEGIN 
    DECLARE jml_pinjam INT;
    DECLARE Keterangan VARCHAR(100);

    SELECT COUNT(*) INTO jml_pinjam FROM anggota WHERE id_anggota = ururanAgt AND status_pinjam = 'meminjam';

    IF jml_pinjam > 0 THEN    
	SET Keterangan = 'Buku Belum Dikembalikan';
    
    ELSE 
	DELETE FROM anggota WHERE  id_anggota = urutanAgt;
	SET Keterangan = 'Buku Telah Dihapus'; 
    END IF;
    
    SELECT Keterangan;
END //
DELIMITER ;

CALL hapusData(2);


-- nomer6
CREATE DATABASE sekolah;

USE sekolah;

CREATE TABLE IF NOT EXISTS  student(
id_siswa VARCHAR (10) NOT NULL PRIMARY KEY,
NAME VARCHAR (30) NOT NULL,
age INT (3) NOT NULL,
gender VARCHAR (20) NOT NULL
);

INSERT INTO student VALUES 
('r01','rehan',16,'Pria'),
('r02','sigma',16,'Pria'),
('r03','rafly',15,'Pria');


CREATE TABLE IF NOT EXISTS courses (
id_course VARCHAR (10) NOT NULL PRIMARY KEY,
course_name VARCHAR (30) NOT NULL,
credits VARCHAR(10) NOT NULL 
);

INSERT INTO courses VALUES
('C01','IPA','2'),
('C02','IPS','3'),
('C03','Sejarah','4');

SELECT * FROM courses;



CREATE TABLE IF NOT EXISTS student_course(
id_student_course VARCHAR (10)NOT NULL PRIMARY KEY,
grade VARCHAR (10) NOT NULL,
id_course VARCHAR (10) NOT NULL,
FOREIGN KEY (id_course) REFERENCES courses(id_course)
);

SELECT * FROM student_course

INSERT INTO student_course VALUES
('SC01','A','C01'),
('SC02','B+','C03'),
('SC03','B','C02');



CREATE TABLE IF NOT EXISTS teachers (
id_teachers VARCHAR (10) NOT NULL PRIMARY KEY,
NAME VARCHAR (30) NOT NULL,
SUBJECT VARCHAR (30) NOT NULL
);

INSERT INTO teachers VALUES
('TC01','beni','IPA'),
('TC02','haqi','IPS'),
('TC03','fairus','Sejarah');


CREATE TABLE IF NOT EXISTS courses_teachers (
id_courses_teachers VARCHAR (10) NOT NULL PRIMARY KEY,
id_teachers VARCHAR (10) NOT NULL,
FOREIGN KEY (id_teachers) REFERENCES teachers (id_teachers)
);

INSERT INTO courses_teachers VALUES
('STC01','TC01'),
('STC02','TC02'),
('STC03','TC02');

SELECT * FROM courses_teachers

CREATE VIEW mengajarlebihsatu AS
SELECT NAME, SUBJECT AS Mata_Pelajaran, COUNT(a.id_teachers) AS Jumlah_Ajar
FROM teachers a
INNER JOIN courses_teachers b ON a.id_teachers = b.id_teachers
GROUP BY NAME
HAVING COUNT(Jumlah_Ajar) > 1;




