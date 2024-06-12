1. Membuat Database dan Tabel: database bernama "toko_buku" dan membuat tabel "Penulis" dengan kolom id_penulis sebagai primary key (PK), nama, dan negara.membuat tabel "Buku" dengan kolom id_buku sebagai primary key (PK), judul, id_penulis sebagai foreign key (FK) yang merujuk ke tabel Penulis, harga, dan stok. Membuat tabel "Penjualan" dengan kolom id_penjualan sebagai primary key (PK), id_buku sebagai foreign key (FK) yang merujuk ke tabel Buku, tanggal, dan jumlah.Tambahkan data ke tabel Penulis dan Buku.

2. Buat View "viewBukuPenulis": Membuat view yang menampilkan informasi tentang buku beserta nama penulisnya. View ini memiliki kolom-kolom: judul buku, harga, stok, nama penulis, dan negara penulis.

3. Tampilkan 5 Data Pertama dari View "viewBukuPenulis" dari Harga Termurah ke Termahal: Tampilkan 5 data pertama dari view "viewBukuPenulis". Urutkan data dari harga termurah ke termahal dengan menggunakan ASC dan LIMIT.

4. Membuat Stored Procedure "insertToPenjualan": Membuat stored procedure untuk menambahkan data pada tabel Penjualan. Procedure ini memeriksa apakah id_buku yang menjadi kunci tamu dari tabel Buku tersedia. Jika tersedia, tambahkan data ke dalam tabel Penjualan dengan peringatan "Penjualan Berhasil ditambahkan". Jika tidak, tampilkan peringatan "Id Buku Tidak Tersedia. Penjualan gagal dilakukan!".

5. Membuat View "penjualanTerbanyak": Membuat view yang menampilkan judul buku, nama penulis, dan total penjualan. Data diambil dari masing-masing tabel menggunakan JOIN antar tabel. Kelompokkan berdasarkan id_buku dan urutkan berdasarkan jumlah penjualan terbanyak.
Tampilkan view dengan maksimal 5 baris.

6. Membuat Stored Procedure "insertToBuku": Membuat stored procedure untuk menambahkan buku baru ke dalam sistem. Pastikan untuk memeriksa apakah buku tersebut sudah ada dalam database sebelum menambahkannya. Jika buku belum ada, tambahkan buku ke dalam tabel Buku dengan harga dan stok awal yang ditentukan.