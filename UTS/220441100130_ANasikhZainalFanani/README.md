1. Membuat Database dan Tabel 
   - Pertama, kode `CREATE DATABASE IF NOT EXISTS toko_buku;` membuat database dengan nama "toko_buku" jika belum ada.
   - Kemudian, perintah `USE toko_buku;` digunakan untuk beralih ke database yang baru dibuat.
   - Selanjutnya, dibuat tiga tabel yaitu `Penulis`, `Buku`, dan `Penjualan`. `Penulis` memiliki kolom ID penulis, nama, dan negara asal. `Buku` memiliki kolom ID buku, judul, ID penulis (sebagai kunci asing), harga, dan stok. `Penjualan` memiliki kolom ID penjualan, ID buku (sebagai kunci asing), tanggal penjualan, dan jumlah penjualan.

2. Menambahkan Data ke Tabel Penulis dan Buku
   - Data penulis dan buku dimasukkan menggunakan perintah `INSERT INTO`.
   - Untuk tabel `Penulis`, data nama penulis dan negara asalnya dimasukkan.
   - Untuk tabel `Buku`, data judul buku, ID penulis (yang sudah ada dalam tabel `Penulis`), harga, dan stok dimasukkan.

3. Membuat View "viewBukuPenulis"
   - View `viewBukuPenulis` dibuat untuk menampilkan informasi tentang buku beserta nama penulisnya.
   - Query dalam view ini menggabungkan informasi dari tabel `Buku` dan `Penulis` menggunakan `JOIN`.
   - View memiliki kolom-kolom seperti judul buku, harga, stok, nama penulis, dan negara penulis.

4. Membuat Stored Procedure "tambahPenjualan"
   - Stored procedure ini bertujuan untuk menambahkan data penjualan baru ke dalam tabel `Penjualan`.
   - Procedure ini menerima input ID buku, tanggal penjualan, dan jumlah penjualan.
   - Procedure akan memeriksa apakah stok buku mencukupi sebelum menambahkan data penjualan baru.
   - Hasil dari proses ini disimpan dalam variabel `result`.

5. Membuat View "penjualanTerbanyak"
   - View ini dibuat untuk menampilkan daftar buku yang paling banyak terjual.
   - Query dalam view ini melakukan join antara tabel `Penjualan`, `Buku`, dan `Penulis`, kemudian menghitung total penjualan untuk setiap buku.
   - Data yang ditampilkan adalah judul buku, nama penulis, dan total penjualan, dengan diurutkan berdasarkan total penjualan dari yang tertinggi.

6. Membuat Stored Procedure "insertToBuku"
   - Stored procedure ini bertujuan untuk menambahkan buku baru ke dalam sistem.
   - Procedure ini menerima input judul buku, ID penulis, harga, dan stok.
   - Sebelum menambahkan data, procedure akan memeriksa apakah buku dengan judul dan penulis yang sama sudah ada dalam database.
   - Hasil dari proses ini disimpan dalam variabel `result`.

