# Dokumentasi Fitur Aplikasi Mobile PLP

## 5.4 Implementasi Fitur

Berikut adalah implementasi fitur-fitur utama pada aplikasi mobile PLP menggunakan Flutter dengan GetX sebagai state management.

### Fitur Login

| No | Kode |
|----|------|
| 13 | `final controller = Get.put(LoginController());` |
| 33-38 | `CustomTextField(controller: controller.emailController, hintText: "Email @...ub.ac.id", keyboardType: TextInputType.emailAddress)` |
| 42-80 | `Obx(() => TextField(controller: controller.passwordController, obscureText: !controller.isPasswordVisible.value, decoration: InputDecoration(hintText: "Password", suffixIcon: IconButton(icon: Icon(controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off), onPressed: controller.togglePasswordVisibility))))` |
| 102-111 | `Obx(() => CustomButton(text: "MASUK", color: Colors.blue, shadowColor: Colors.blue.shade700, onTap: controller.login, isPressed: controller.isLoginPressed.value))` |

Untuk menginisialisasi komponen yang akan digunakan pada halaman login, maka digunakan `Get.put(LoginController())` yang merupakan controller dari GetX untuk mengelola state dan logika bisnis. Controller ini mencakup data `emailController` dan `passwordController` untuk mengelola input field, serta `isPasswordVisible` untuk mengatur visibilitas password. Ketika user mengisi form dan menekan tombol "MASUK", maka akan menjalankan method `controller.login()` yang akan mengirim data ke backend API melalui service `AuthService.login()` dengan method POST.

![Tampilan halaman login](path/to/login-screenshot.png)

---

### Fitur Pendaftaran Akun

| No | Kode |
|----|------|
| 13 | `final controller = Get.put(CreateprofileController());` |
| 33-37 | `CustomTextField(hintText: "Nama Lengkap", controller: controller.nameController)` |
| 41-45 | `CustomTextField(hintText: "Email", controller: controller.emailController)` |
| 49-79 | `Obx(() => TextField(controller: controller.passwordController, obscureText: !controller.isPasswordVisible.value, decoration: InputDecoration(...)))` |
| 125-136 | `Obx(() => CustomButton(text: "CREATE ACCOUNT", color: Colors.blue, onTap: () { controller.createAccount(); }, isPressed: controller.isCreateAccountPressed.value))` |

Fitur pendaftaran akun digunakan untuk mendaftar sebagai mahasiswa PLP. Saat membuat objek `CreateprofileController`, maka data yang perlu dimasukkan adalah nama lengkap, email, password, dan konfirmasi password. Controller menggunakan reactive state dari GetX (Obx) untuk mengelola perubahan nilai input secara real-time. Setelah selesai mengisi form dan diklik submit, maka data akan dikirimkan ke backend API melalui method `controller.createAccount()` yang memanggil service `AuthService.register()` dengan method POST.

![Tampilan halaman daftar akun](path/to/register-screenshot.png)

---

### Fitur Pendaftaran PLP

| No | Kode |
|----|------|
| 13 | `final controller = Get.put(PendaftaranplpController());` |
| 24-38 | `DropdownButtonFormField<int>(value: controller.selectedKeminatanId.value, items: controller.keminatanList.map((k) => DropdownMenuItem(value: k['id'], child: Text(k['name']))).toList(), onChanged: (val) => controller.selectedKeminatanId.value = val!)` |
| 43-55 | `DropdownButtonFormField<String>(value: controller.selectedNilaiPlp1.value, items: controller.nilaiOptions.map((nilai) => DropdownMenuItem(value: nilai, child: Text(nilai))).toList(), onChanged: (val) => controller.selectedNilaiPlp1.value = val!)` |
| 127-135 | `CustomButton(text: "DAFTAR", color: Colors.blue, shadowColor: Colors.blue.shade700, onTap: controller.submitPendaftaran, isPressed: controller.isSubmitting.value)` |

Pada halaman ini, data keminatan dan SMK yang tersedia di database diambil melalui API dan disimpan dalam controller sebagai reactive state. Dropdown menggunakan `DropdownButtonFormField` dengan value yang di-bind ke controller menggunakan reactive variable (`.value`). Setiap perubahan pada dropdown akan langsung mengupdate state di controller. Setelah divalidasi bahwa semua data terisi, saat di-submit akan menjalankan method `controller.submitPendaftaran()` yang mengirimkan data keminatan, nilai PLP 1, nilai micro teaching, dan pilihan SMK ke backend API melalui service `PendaftaranPlpService.submitPendaftaranPlp()` dengan method POST.

![Tampilan halaman pendaftaran PLP](path/to/pendaftaran-screenshot.png)

---

### Fitur Penentuan Lokasi dan Pembimbing PLP

| No | Kode |
|----|------|
| 32-44 | `final Rxn<SmkModel> selectedSmk = Rxn<SmkModel>(); final Rxn<UserModel> selectedDospem = Rxn<UserModel>(); final Rxn<UserModel> selectedGuruPamong = Rxn<UserModel>();` |
| 250-267 | `Obx(() => DropdownButtonFormField<SmkModel>(value: selectedSmk.value, hint: const Text('Pilih SMK'), items: smkList.map((smk) => DropdownMenuItem(value: smk, child: Text(smk.nama))).toList(), onChanged: (value) => selectedSmk.value = value))` |
| 420-445 | `ElevatedButton(onPressed: () { if (selectedSmk.value == null ...) }, child: Text('Assign'))` |

Pada halaman penentuan penempatan PLP, menggunakan `Rxn` (Reactive Nullable) dari GetX untuk mengelola state dropdown yang bersifat nullable. Setiap dropdown (SMK, Dosen Pembimbing, dan Guru Pamong) dibungkus dengan `Obx()` agar perubahan nilai reactive. Saat pengguna memilih dari dropdown, nilai akan tersimpan ke reactive variable. Ketika diklik tombol "Assign", sistem akan memvalidasi terlebih dahulu apakah semua dropdown telah dipilih. Jika ya, maka data akan dikirim ke backend melalui callback `onAssign()` yang memanggil service `PendaftaranPlpService.assignPenempatanDospem()` dengan method PATCH untuk mengupdate data penempatan mahasiswa.

![Tampilan halaman penentuan lokasi dan pembimbing PLP](path/to/assign-screenshot.png)

---

### Fitur Pengisian Logbook

| No | Kode |
|----|------|
| 23-30 | `Obx(() { if (controller.isLoading.value) { return const Center(child: CircularProgressIndicator()); } if (controller.logbookList.isEmpty) { return const Center(child: Text("Belum ada logbook")); } })` |
| 32-42 | `return ListView.builder(padding: const EdgeInsets.only(bottom: 100), itemCount: controller.logbookList.length, itemBuilder: (context, index) { final logbook = controller.logbookList[index]; ... })` |
| 53-72 | `Column(children: [IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { Get.defaultDialog(title: "Konfirmasi", onConfirm: () { controller.deleteLogbook(logbook.id); }); }), IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () { controller.goToEditLogbook(logbook); })])` |
| 126-139 | `Obx(() => CustomButton(text: "TAMBAH LOGBOOK", color: const Color(0xFF58CC02), shadowColor: Colors.green.shade700, onTap: () { controller.goToTambahLogbook(); }, isPressed: controller.isStartButtonPressed.value))` |

Ketika halaman ini dibuka, sistem akan mengambil data semua logbook mahasiswa dari API melalui method `controller.fetchLogbooks()` dan menyimpannya dalam reactive list `logbookList`. State loading dan empty state dikelola menggunakan `Obx()` untuk menampilkan UI yang sesuai. Setiap item logbook dilengkapi dengan tombol delete yang akan menjalankan method `controller.deleteLogbook(id)` untuk menghapus logbook dengan method DELETE ke API endpoint `/logbooks/{id}`. Tombol edit akan membuka halaman form edit dengan data logbook yang sudah terisi. Tombol "TAMBAH LOGBOOK" akan navigasi ke halaman form logbook baru.

![Tampilan halaman manajemen logbook](path/to/logbook-list-screenshot.png)

![Tampilan halaman saat membuat logbook baru](path/to/logbook-form-screenshot.png)

---

### Fitur Validasi Logbook

| No | Kode |
|----|------|
| 16-35 | `Obx(() { if (controller.isLoading.value) { return const Center(child: CircularProgressIndicator()); } if (controller.errorMessage.isNotEmpty) { return Center(child: Text(controller.errorMessage.value)); } if (controller.logbooks.isEmpty) { return const Center(child: Text('Tidak ada logbook untuk divalidasi.')); } })` |
| 37-44 | `return ListView.separated(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), itemCount: controller.logbooks.length, separatorBuilder: (_, __) => const Divider(height: 1), itemBuilder: (context, index) { final logbook = controller.logbooks[index]; ... })` |
| 70-85 | `trailing: Wrap(spacing: 4, children: [IconButton(tooltip: 'Setujui logbook', icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => _onValidatePressed(context, logbook.id, 'approved')), IconButton(tooltip: 'Tolak logbook', icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () => _onValidatePressed(context, logbook.id, 'rejected'))])` |

Saat halaman ini diakses oleh dosen pembimbing maupun guru pamong, sistem akan mengambil data logbook dari mahasiswa yang dibimbing melalui API endpoint `/logbooks/validasi` dan menyimpannya dalam reactive list menggunakan controller. State management menggunakan `Obx()` untuk menampilkan loading indicator, error message, atau empty state sesuai kondisi. Setiap logbook ditampilkan dalam Card dengan dua tombol aksi: approve (ikon centang hijau) dan reject (ikon silang merah). Saat tombol validasi diklik, akan muncul dialog konfirmasi terlebih dahulu. Setelah dikonfirmasi, method `controller.validateLogbook(id, action)` akan dipanggil yang mengirim data ke backend melalui service `LogbookService.updateValidationStatus()` dengan method PUT ke endpoint `/logbooks/validasi/{id}`.

![Tampilan halaman validasi logbook](path/to/validasi-screenshot.png)

---

### Fitur Input Data Akademik (Buat Akun)

| No | Kode |
|----|------|
| 20-42 | `TextFormField(onChanged: (value) { controller.name.value = value; }, decoration: _inputDecoration("Masukkan nama")) ... TextFormField(onChanged: (value) { controller.email.value = value; }, keyboardType: TextInputType.emailAddress, decoration: _inputDecoration("Masukkan email"))` |
| 73-86 | `DropdownButtonFormField<String>(value: controller.selectedRole.value, items: controller.roleOptions.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(), onChanged: (val) { controller.selectedRole.value = val!; })` |
| 157-172 | `CustomButton(text: "BUAT AKUN", color: Colors.green, shadowColor: Colors.green.shade700, onTap: controller.submitBuatAkun, isPressed: controller.isSubmitting.value)` |

CRUD data dapat dilakukan oleh akademik terhadap berbagai tabel meliputi akun guru, akun dosen, data SMK, data guru pamong, dan data keminatan. Pada halaman pembuatan akun, setiap field input menggunakan callback `onChanged` yang mengupdate reactive variable di controller secara real-time. Field role menggunakan dropdown dengan pilihan yang telah ditentukan dalam `controller.roleOptions`. Terdapat juga fitur dynamic detail fields yang memungkinkan akademik menambah field tambahan seperti NIK, tanggal lahir, dll. Ketika tombol "BUAT AKUN" diklik, method `controller.submitBuatAkun()` akan melakukan validasi terlebih dahulu (cek email format, password match, dll). Jika valid, data akan dikirim ke backend melalui service `AkunService.createAccount()` dengan method POST. Password untuk akun baru akan di-generate otomatis jika diperlukan.

![Tampilan halaman kelola data akun (buat akun)](path/to/buat-akun-screenshot.png)

---

## 5.5 Pengujian Program

Untuk memastikan bahwa aplikasi mobile dapat digunakan oleh setiap aktor serta benar-benar sesuai dengan kebutuhan yang telah dirancang, dilakukanlah proses pengujian kepada beberapa pihak yang memiliki peran langsung maupun tidak langsung dalam penggunaannya. Pihak yang terlibat dalam pengujian ini meliputi dosen pada Program Studi Pendidikan Teknologi Informasi, ketua program studi, pihak akademik, serta mahasiswa dari Program Studi Pendidikan Teknologi Informasi. Keterlibatan berbagai pihak ini bertujuan untuk memperoleh sudut pandang yang komprehensif, sehingga dapat dipastikan bahwa aplikasi mobile mampu mendukung kebutuhan pengguna dari berbagai level dan fungsi.

Proses pengujian diawali dengan penyusunan berbagai skenario penggunaan yang merepresentasikan fitur dan alur kerja utama pada aplikasi. Setiap skenario dirancang sedetail mungkin agar dapat mencerminkan situasi nyata yang berpotensi terjadi di lapangan. Para penguji kemudian mencoba menjalankan skenario-skenario tersebut sesuai dengan peran atau hak akses yang mereka miliki melalui aplikasi mobile, lalu memberikan penilaian terkait keberhasilan fungsinya, kemudahan penggunaan (user experience), dan responsivitas aplikasi. Apabila ditemukan kendala atau ketidaksesuaian, masukan dari para penguji akan digunakan sebagai dasar untuk melakukan perbaikan pada aplikasi mobile, sehingga sistem dapat beroperasi secara optimal sesuai dengan kebutuhan pada kegiatan PLP.

---

## Penjelasan Teknologi dan Pattern yang Digunakan

### State Management dengan GetX

Aplikasi ini menggunakan GetX sebagai state management yang menyediakan:

- **Reactive Programming**: Menggunakan `.obs` dan `Obx()` untuk membuat UI yang reaktif terhadap perubahan data
- **Dependency Injection**: Menggunakan `Get.put()` dan `Get.find()` untuk mengelola controller
- **Navigation**: Menggunakan `Get.toNamed()` dan `Get.back()` untuk navigasi antar halaman
- **Snackbar**: Menggunakan `Get.snackbar()` untuk menampilkan notifikasi

### Komunikasi dengan Backend

Aplikasi berkomunikasi dengan backend Laravel melalui REST API:

- **HTTP Client**: Menggunakan package `http` untuk melakukan request ke API
- **Service Layer**: Setiap fitur memiliki service class (AuthService, LogbookService, dll) yang menangani komunikasi dengan API
- **Token Authentication**: Menggunakan Bearer token yang disimpan di GetStorage untuk autentikasi
- **Auto-login**: Aplikasi mengecek token saat startup untuk auto-login user

### Data Persistence

- **GetStorage**: Digunakan untuk menyimpan data lokal seperti token dan user info
- **Auto-initialize**: GetStorage diinisialisasi saat aplikasi dimulai di `main.dart`

### Widget Reusability

- **Custom Widgets**: Membuat widget yang dapat digunakan kembali seperti `CustomButton`, `CustomTextField`, dan `RoundedMenuItem`
- **Custom Navbar**: Navigation bar yang konsisten di seluruh aplikasi
