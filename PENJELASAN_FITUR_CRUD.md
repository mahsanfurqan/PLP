# Penjelasan Fitur Kelola Data Akademik

Dokumen ini menjelaskan cara kerja tiga fitur utama untuk mengelola data dalam aplikasi PLP, yaitu: Tambah SMK, Tambah Keminatan, dan Buat Akun.

---

## 1. Fitur Tambah SMK

### Apa yang dilakukan fitur ini?
Fitur ini digunakan oleh staf akademik untuk menambahkan data Sekolah Menengah Kejuruan (SMK) baru ke dalam sistem. Data SMK ini nantinya akan digunakan saat mahasiswa mendaftar PLP atau saat akademik menentukan penempatan mahasiswa.

### Tampilan Halaman

**Judul Halaman:**
Bagian paling atas halaman menampilkan tulisan "List SMK" yang berada di tengah.

**Daftar SMK:**
Halaman menampilkan daftar semua SMK yang sudah terdaftar dalam bentuk kartu-kartu. Setiap kartu memiliki:
- **Bagian kiri:** Menampilkan ID SMK dengan format 3 digit (contoh: 001, 002, 015)
- **Bagian kanan:** Menampilkan nama lengkap SMK (contoh: "SMK : SMK Negeri 1 Malang")

Kartu-kartu ini ditampilkan secara vertikal, bisa di-scroll ke bawah jika data SMK banyak.

**Tombol Tambah SMK:**
Di bagian bawah halaman terdapat tombol berwarna hijau dengan tulisan "TAMBAH SMK". Tombol ini:
- Hanya muncul untuk pengguna dengan role tertentu (tidak muncul untuk Dosen Pembimbing)
- Saat diklik, akan membuka jendela pop-up untuk menambah SMK baru
- Saat sedang menyimpan data, tombol akan berubah menjadi animasi loading (bulatan berputar)

### Proses Menambah SMK Baru

**Langkah 1 - Membuka Form:**
Ketika tombol "TAMBAH SMK" diklik, muncul jendela pop-up dengan judul "Tambah SMK Baru".

**Langkah 2 - Mengisi Form:**
Di jendela pop-up terdapat kotak input dengan label "Nama SMK". Pengguna mengetikkan nama SMK yang ingin ditambahkan.

**Langkah 3 - Menyimpan Data:**
Setelah mengisi nama SMK, pengguna menekan tombol "SIMPAN" berwarna orange. Sistem akan:
1. Mengecek apakah nama SMK sudah diisi atau masih kosong
2. Jika kosong, muncul notifikasi merah "Gagal - Nama SMK tidak boleh kosong"
3. Jika sudah diisi, jendela pop-up ditutup dan muncul animasi loading
4. Data dikirim ke server untuk disimpan
5. Setelah berhasil, daftar SMK otomatis diperbarui dan SMK baru muncul dalam daftar

---

## 2. Fitur Tambah Keminatan

### Apa yang dilakukan fitur ini?
Fitur ini digunakan untuk menambahkan pilihan keminatan baru dalam program studi. Keminatan adalah bidang spesialisasi yang bisa dipilih mahasiswa (contoh: Rekayasa Perangkat Lunak, Multimedia, Jaringan Komputer, dll).

### Tampilan Halaman

**Judul Halaman:**
Bagian atas halaman menampilkan tulisan "List Keminatan" di tengah.

**Daftar Keminatan:**
Sama seperti halaman SMK, halaman ini menampilkan daftar keminatan dalam bentuk kartu-kartu. Setiap kartu menampilkan:
- **Bagian kiri:** ID Keminatan dalam format 3 digit (contoh: 001, 002, 010)
- **Bagian kanan:** Nama keminatan (contoh: "Keminatan : Rekayasa Perangkat Lunak")

Kartu-kartu ini bisa di-scroll jika ada banyak pilihan keminatan.

**Tombol Tambah Keminatan:**
Di bagian bawah halaman terdapat tombol hijau bertuliskan "TAMBAH KEMINATAN". Tombol ini:
- Bisa diakses oleh semua pengguna yang memiliki akses ke halaman ini
- Saat diklik akan membuka jendela pop-up
- Berubah menjadi animasi loading saat sedang menyimpan data

### Proses Menambah Keminatan Baru

**Langkah 1 - Membuka Form:**
Klik tombol "TAMBAH KEMINATAN" akan memunculkan jendela pop-up dengan judul "Tambah Keminatan Baru".

**Langkah 2 - Mengisi Nama Keminatan:**
Di jendela pop-up terdapat kotak input dengan label "Nama Keminatan". Pengguna mengetikkan nama keminatan yang ingin ditambahkan (contoh: "Animasi").

**Langkah 3 - Menyimpan:**
Setelah mengisi, pengguna menekan tombol "SIMPAN" berwarna orange. Sistem akan:
1. Memeriksa apakah nama keminatan sudah diisi
2. Jika kosong, muncul pesan error "Gagal - Nama keminatan tidak boleh kosong"
3. Jika sudah diisi, jendela ditutup dan muncul animasi loading
4. Data dikirim ke server
5. Daftar keminatan otomatis diperbarui dengan data terbaru

---

## 3. Fitur Buat Akun

### Apa yang dilakukan fitur ini?
Fitur ini digunakan oleh staf akademik untuk membuat akun baru untuk berbagai pengguna sistem seperti dosen, guru pamong, atau akademik lainnya. Berbeda dengan pendaftaran mahasiswa yang dilakukan sendiri, pembuatan akun ini dilakukan oleh admin/akademik.

### Tampilan Halaman

**Judul Halaman:**
Bagian atas menampilkan tulisan "Buat Akun" di tengah.

**Form Isian:**
Halaman ini berbentuk formulir panjang yang bisa di-scroll ke bawah. Formulir ini terdiri dari beberapa bagian:

### Bagian 1: Data Wajib

**1. Nama Lengkap:**
- Kotak input untuk mengetik nama lengkap pengguna
- Contoh: "Dr. Ahmad Fauzi, M.Kom"

**2. Email:**
- Kotak input khusus email (keyboard otomatis menampilkan tombol @ dan .com)
- Contoh: "ahmad.fauzi@ub.ac.id"

**3. Password:**
- Kotak input dengan karakter tersembunyi (muncul bintang/titik saat mengetik)
- Untuk keamanan akun yang dibuat

**4. Konfirmasi Password:**
- Kotak input kedua untuk mengetik ulang password yang sama
- Memastikan password tidak salah ketik

**5. Role (Peran):**
- Menu dropdown untuk memilih peran/jabatan pengguna
- Pilihan bisa: Dosen, Guru Pamong, Akademik, Kaprodi, dll.
- Cukup klik kotak, lalu pilih dari daftar yang muncul

### Bagian 2: Detail Tambahan (Opsional)

**Judul Bagian:**
Terdapat keterangan "Detail Tambahan (Opsional)" dengan penjelasan kecil "Tambahkan detail tambahan seperti NIK, TTL, dll"

**Field Detail yang Bisa Ditambah Sendiri:**
Bagian ini unik karena pengguna bisa menambahkan informasi apapun sesuai kebutuhan. Setiap detail terdiri dari:
- **Kotak "Nama Field":** Untuk mengetik nama informasi (contoh: "NIK", "Tempat Lahir", "No. HP")
- **Kotak "Nilai":** Untuk mengetik isi informasinya (contoh: "3573012345678901", "Malang", "081234567890")
- **Tombol Hapus (ikon tong sampah merah):** Untuk menghapus detail jika tidak diperlukan

**Tombol "Tambah Detail":**
Tombol dengan ikon plus (+) untuk menambahkan kotak detail baru. Bisa diklik berkali-kali untuk menambah banyak detail sesuai kebutuhan.

### Tombol Simpan

**Tombol "BUAT AKUN":**
- Tombol besar berwarna hijau di bagian bawah formulir
- Saat diklik, sistem akan:
  1. Memeriksa semua data wajib sudah diisi
  2. Memastikan password dan konfirmasi password sama
  3. Memvalidasi format email
  4. Menampilkan animasi loading
  5. Mengirim data ke server untuk membuat akun baru
  6. Menampilkan notifikasi sukses atau gagal

### Proses Pengisian Form

**Langkah 1 - Mengisi Data Wajib:**
Pengguna mengisi semua kotak input dari atas: nama, email, password (2x), dan memilih role dari dropdown.

**Langkah 2 - Menambah Detail (Jika Perlu):**
Jika ingin menambahkan informasi tambahan:
1. Klik tombol "Tambah Detail"
2. Muncul kotak baru dengan 2 field
3. Ketik nama informasi di kotak pertama (contoh: "NIDN")
4. Ketik nilainya di kotak kedua (contoh: "0123456789")
5. Bisa ditambah lagi dengan klik "Tambah Detail" lagi
6. Jika salah, klik ikon tong sampah merah untuk menghapus

**Langkah 3 - Menyimpan:**
Setelah semua data lengkap, klik tombol hijau "BUAT AKUN". Sistem akan:
- Menampilkan animasi loading (tombol berubah)
- Mengirim data ke server
- Jika berhasil: muncul notifikasi sukses, form dikosongkan
- Jika gagal: muncul pesan error (contoh: "Email sudah terdaftar")

---

## Kesamaan dari Ketiga Fitur

### 1. Tampilan yang Konsisten
Ketiga fitur menggunakan desain yang sama:
- Judul di bagian atas tengah
- Daftar data dalam bentuk kartu dengan ID dan nama
- Tombol aksi di bagian bawah dengan warna yang sama (hijau)
- Jendela pop-up untuk input data baru

### 2. Animasi Loading
Semua fitur menampilkan animasi loading (lingkaran berputar) saat:
- Pertama kali membuka halaman (mengambil data dari server)
- Sedang menyimpan data baru
- Ini memberikan umpan balik visual bahwa sistem sedang bekerja

### 3. Validasi Input
Sebelum menyimpan data, sistem selalu:
- Memeriksa apakah semua field wajib sudah diisi
- Menampilkan pesan error jika ada yang kosong
- Mencegah data tidak lengkap masuk ke database

### 4. Notifikasi
Pengguna selalu mendapat feedback berupa:
- **Notifikasi merah:** Jika terjadi kesalahan (contoh: field kosong, email tidak valid)
- **Notifikasi hijau:** Jika data berhasil disimpan
- Notifikasi muncul di bagian atas layar dan hilang otomatis

### 5. Pembaruan Data Otomatis
Setelah berhasil menambah data baru:
- Tidak perlu refresh halaman secara manual
- Daftar data langsung diperbarui
- Data baru langsung muncul di daftar

### 6. Kemudahan Penggunaan
Semua fitur dirancang sederhana:
- Minimal klik (1-2 klik untuk membuka form)
- Input yang jelas dengan label
- Tombol dengan warna berbeda untuk fungsi berbeda (hijau = tambah, orange = simpan)
- Bisa di-scroll jika konten panjang

---

## Keamanan dan Akses

**Kontrol Akses:**
- Beberapa fitur hanya bisa diakses oleh role tertentu
- Contoh: Dosen Pembimbing tidak bisa menambah SMK
- Sistem otomatis menyembunyikan tombol yang tidak boleh diakses

**Perlindungan Data:**
- Password tersembunyi saat diketik (muncul titik/bintang)
- Validasi email memastikan format yang benar
- Konfirmasi password mencegah kesalahan ketik

**Pencegahan Error:**
- Semua input wajib harus diisi
- Format data diperiksa sebelum dikirim
- Pesan error yang jelas membantu pengguna memperbaiki kesalahan
