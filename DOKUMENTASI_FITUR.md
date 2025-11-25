# Dokumentasi Fitur Aplikasi Mobile PLP

## 5.4 Implementasi Fitur

Berikut adalah implementasi fitur-fitur utama pada aplikasi mobile PLP menggunakan Flutter dengan GetX sebagai state management.

### Fitur Login

| No | Kode |
|----|------|
| 13 | ```dart<br>final controller = Get.put(LoginController());``` |
| 33-38 | ```dart<br>CustomTextField(<br>  controller: controller.emailController,<br>  hintText: "Email @...ub.ac.id",<br>  keyboardType: TextInputType.emailAddress,<br>),``` |
| 42-80 | ```dart<br>Obx(<br>  () => TextField(<br>    controller: controller.passwordController,<br>    obscureText: !controller.isPasswordVisible.value,<br>    style: const TextStyle(color: Colors.black87),<br>    decoration: InputDecoration(<br>      hintText: "Password",<br>      hintStyle: const TextStyle(color: Colors.black12),<br>      filled: true,<br>      fillColor: Colors.grey[200],<br>      suffixIcon: IconButton(<br>        icon: Icon(<br>          controller.isPasswordVisible.value<br>              ? Icons.visibility<br>              : Icons.visibility_off,<br>          color: Colors.blue,<br>        ),<br>        onPressed: controller.togglePasswordVisibility,<br>      ),<br>    ),<br>  ),<br>)``` |
| 102-111 | ```dart<br>Obx(<br>  () => CustomButton(<br>    text: "MASUK",<br>    color: Colors.blue,<br>    shadowColor: Colors.blue.shade700,<br>    onTap: controller.login,<br>    isPressed: controller.isLoginPressed.value,<br>  ),<br>)``` |

Untuk menginisialisasi komponen yang akan digunakan pada halaman login, maka digunakan `Get.put(LoginController())` yang merupakan controller dari GetX untuk mengelola state dan logika bisnis. Controller ini mencakup data `emailController` dan `passwordController` untuk mengelola input field, serta `isPasswordVisible` untuk mengatur visibilitas password. Ketika user mengisi form dan menekan tombol "MASUK", maka akan menjalankan method `controller.login()` yang akan mengirim data ke backend API melalui service `AuthService.login()` dengan method POST.

![Tampilan halaman login](path/to/login-screenshot.png)

---

### Fitur Pendaftaran Akun

| No | Kode |
|----|------|
| 13 | ```dart<br>final controller = Get.put(CreateprofileController());``` |
| 33-37 | ```dart<br>CustomTextField(<br>  hintText: "Nama Lengkap",<br>  controller: controller.nameController,<br>),``` |
| 41-45 | ```dart<br>CustomTextField(<br>  hintText: "Email",<br>  controller: controller.emailController,<br>),``` |
| 49-79 | ```dart<br>Obx(<br>  () => TextField(<br>    controller: controller.passwordController,<br>    obscureText: !controller.isPasswordVisible.value,<br>    style: const TextStyle(color: Colors.black87),<br>    decoration: InputDecoration(<br>      hintText: "Password",<br>      hintStyle: const TextStyle(color: Colors.black12),<br>      filled: true,<br>      fillColor: Colors.grey[200],<br>      suffixIcon: IconButton(<br>        icon: Icon(<br>          controller.isPasswordVisible.value<br>              ? Icons.visibility<br>              : Icons.visibility_off,<br>          color: Colors.blue,<br>        ),<br>        onPressed: controller.togglePasswordVisibility,<br>      ),<br>    ),<br>  ),<br>)``` |
| 125-136 | ```dart<br>Obx(<br>  () => CustomButton(<br>    text: "CREATE ACCOUNT",<br>    color: Colors.blue,<br>    shadowColor: Colors.blue.shade700,<br>    onTap: () {<br>      controller.createAccount();<br>    },<br>    isPressed: controller.isCreateAccountPressed.value,<br>  ),<br>)``` |

Fitur pendaftaran akun digunakan untuk mendaftar sebagai mahasiswa PLP. Saat membuat objek `CreateprofileController`, maka data yang perlu dimasukkan adalah nama lengkap, email, password, dan konfirmasi password. Controller menggunakan reactive state dari GetX (Obx) untuk mengelola perubahan nilai input secara real-time. Setelah selesai mengisi form dan diklik submit, maka data akan dikirimkan ke backend API melalui method `controller.createAccount()` yang memanggil service `AuthService.register()` dengan method POST.

![Tampilan halaman daftar akun](path/to/register-screenshot.png)

---

### Fitur Pendaftaran PLP

| No | Kode |
|----|------|
| 13 | ```dart<br>final controller = Get.put(PendaftaranplpController());``` |
| 24-38 | ```dart<br>DropdownButtonFormField<int>(<br>  value: controller.keminatanList.any(<br>    (e) => e['id'] == controller.selectedKeminatanId.value,<br>  ) ? controller.selectedKeminatanId.value : null,<br>  items: controller.keminatanList.map((keminatan) {<br>    return DropdownMenuItem<int>(<br>      value: keminatan['id'],<br>      child: Text(keminatan['name']),<br>    );<br>  }).toList(),<br>  onChanged: (val) => controller.selectedKeminatanId.value = val!,<br>  decoration: _dropdownDecoration(),<br>)``` |
| 43-55 | ```dart<br>DropdownButtonFormField<String>(<br>  value: controller.nilaiOptions.contains(<br>    controller.selectedNilaiPlp1.value,<br>  ) ? controller.selectedNilaiPlp1.value : null,<br>  items: controller.nilaiOptions.map((nilai) {<br>    return DropdownMenuItem<String>(<br>      value: nilai,<br>      child: Text(nilai),<br>    );<br>  }).toList(),<br>  onChanged: (val) => controller.selectedNilaiPlp1.value = val!,<br>)``` |
| 127-135 | ```dart<br>CustomButton(<br>  text: "DAFTAR",<br>  color: Colors.blue,<br>  shadowColor: Colors.blue.shade700,<br>  onTap: controller.submitPendaftaran,<br>  isPressed: controller.isSubmitting.value,<br>)``` |

Pada halaman ini, data keminatan dan SMK yang tersedia di database diambil melalui API dan disimpan dalam controller sebagai reactive state. Dropdown menggunakan `DropdownButtonFormField` dengan value yang di-bind ke controller menggunakan reactive variable (`.value`). Setiap perubahan pada dropdown akan langsung mengupdate state di controller. Setelah divalidasi bahwa semua data terisi, saat di-submit akan menjalankan method `controller.submitPendaftaran()` yang mengirimkan data keminatan, nilai PLP 1, nilai micro teaching, dan pilihan SMK ke backend API melalui service `PendaftaranPlpService.submitPendaftaranPlp()` dengan method POST.

![Tampilan halaman pendaftaran PLP](path/to/pendaftaran-screenshot.png)

---

### Fitur Penentuan Lokasi dan Pembimbing PLP

| No | Kode |
|----|------|
| 32-44 | ```dart<br>final Rxn<SmkModel> selectedSmk = Rxn<SmkModel>();<br>final Rxn<UserModel> selectedDospem = Rxn<UserModel>();<br>final Rxn<UserModel> selectedGuruPamong = Rxn<UserModel>();<br>``` |
| 250-267 | ```dart<br>Obx(() => DropdownButtonFormField<SmkModel>(<br>  value: selectedSmk.value,<br>  hint: const Text('Pilih SMK'),<br>  items: smkList.map((smk) {<br>    return DropdownMenuItem<SmkModel>(<br>      value: smk,<br>      child: Text(smk.nama),<br>    );<br>  }).toList(),<br>  onChanged: (value) => selectedSmk.value = value,<br>))``` |
| 420-445 | ```dart<br>ElevatedButton(<br>  onPressed: () {<br>    if (selectedSmk.value == null ||<br>        selectedDospem.value == null ||<br>        selectedGuruPamong.value == null) {<br>      Get.snackbar(<br>        "Validasi",<br>        "Mohon pilih SMK, Dosen Pembimbing, dan Guru Pamong",<br>      );<br>      return;<br>    }<br>    onAssign(<br>      registration.id!,<br>      selectedSmk.value!.id!,<br>      selectedDospem.value!.id!,<br>      selectedGuruPamong.value!.id!,<br>    );<br>    Navigator.of(context).pop();<br>  },<br>)``` |

Pada halaman penentuan penempatan PLP, menggunakan `Rxn` (Reactive Nullable) dari GetX untuk mengelola state dropdown yang bersifat nullable. Setiap dropdown (SMK, Dosen Pembimbing, dan Guru Pamong) dibungkus dengan `Obx()` agar perubahan nilai reactive. Saat pengguna memilih dari dropdown, nilai akan tersimpan ke reactive variable. Ketika diklik tombol "Assign", sistem akan memvalidasi terlebih dahulu apakah semua dropdown telah dipilih. Jika ya, maka data akan dikirim ke backend melalui callback `onAssign()` yang memanggil service `PendaftaranPlpService.assignPenempatanDospem()` dengan method PATCH untuk mengupdate data penempatan mahasiswa.

![Tampilan halaman penentuan lokasi dan pembimbing PLP](path/to/assign-screenshot.png)

---

### Fitur Pengisian Logbook

| No | Kode |
|----|------|
| 23-30 | ```dart<br>Obx(() {<br>  if (controller.isLoading.value) {<br>    return const Center(child: CircularProgressIndicator());<br>  }<br>  if (controller.logbookList.isEmpty) {<br>    return const Center(child: Text("Belum ada logbook"));<br>  }``` |
| 32-42 | ```dart<br>return ListView.builder(<br>  padding: const EdgeInsets.only(bottom: 100),<br>  itemCount: controller.logbookList.length,<br>  itemBuilder: (context, index) {<br>    final logbook = controller.logbookList[index];``` |
| 53-72 | ```dart<br>Column(<br>  children: [<br>    IconButton(<br>      icon: const Icon(Icons.delete, color: Colors.red),<br>      onPressed: () {<br>        Get.defaultDialog(<br>          title: "Konfirmasi",<br>          middleText: "Hapus logbook ini?",<br>          onConfirm: () {<br>            Get.back();<br>            controller.deleteLogbook(logbook.id);<br>          },<br>        );<br>      },<br>    ),<br>    IconButton(<br>      icon: const Icon(Icons.edit, color: Colors.blue),<br>      onPressed: () {<br>        controller.goToEditLogbook(logbook);<br>      },<br>    ),<br>  ],<br>)``` |
| 126-139 | ```dart<br>Obx(<br>  () => CustomButton(<br>    text: "TAMBAH LOGBOOK",<br>    color: const Color(0xFF58CC02),<br>    shadowColor: Colors.green.shade700,<br>    onTap: () {<br>      controller.isStartButtonPressed.value = true;<br>      controller.goToTambahLogbook();<br>    },<br>    isPressed: controller.isStartButtonPressed.value,<br>  ),<br>)``` |

Ketika halaman ini dibuka, sistem akan mengambil data semua logbook mahasiswa dari API melalui method `controller.fetchLogbooks()` dan menyimpannya dalam reactive list `logbookList`. State loading dan empty state dikelola menggunakan `Obx()` untuk menampilkan UI yang sesuai. Setiap item logbook dilengkapi dengan tombol delete yang akan menjalankan method `controller.deleteLogbook(id)` untuk menghapus logbook dengan method DELETE ke API endpoint `/logbooks/{id}`. Tombol edit akan membuka halaman form edit dengan data logbook yang sudah terisi. Tombol "TAMBAH LOGBOOK" akan navigasi ke halaman form logbook baru.

![Tampilan halaman manajemen logbook](path/to/logbook-list-screenshot.png)

![Tampilan halaman saat membuat logbook baru](path/to/logbook-form-screenshot.png)

---

### Fitur Validasi Logbook

| No | Kode |
|----|------|
| 16-35 | ```dart<br>Obx(() {<br>  if (controller.isLoading.value) {<br>    return const Center(child: CircularProgressIndicator());<br>  }<br>  if (controller.errorMessage.isNotEmpty) {<br>    return Center(<br>      child: Text(<br>        controller.errorMessage.value,<br>        style: const TextStyle(color: Colors.red, fontSize: 16),<br>      ),<br>    );<br>  }<br>  if (controller.logbooks.isEmpty) {<br>    return const Center(<br>      child: Text('Tidak ada logbook untuk divalidasi.'),<br>    );<br>  }``` |
| 37-44 | ```dart<br>return ListView.separated(<br>  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),<br>  itemCount: controller.logbooks.length,<br>  separatorBuilder: (_, __) => const Divider(height: 1),<br>  itemBuilder: (context, index) {<br>    final logbook = controller.logbooks[index];``` |
| 70-85 | ```dart<br>trailing: Wrap(<br>  spacing: 4,<br>  children: [<br>    IconButton(<br>      tooltip: 'Setujui logbook',<br>      icon: const Icon(Icons.check_circle, color: Colors.green),<br>      onPressed: () => _onValidatePressed(<br>        context,<br>        logbook.id,<br>        'approved',<br>      ),<br>    ),<br>    IconButton(<br>      tooltip: 'Tolak logbook',<br>      icon: const Icon(Icons.cancel, color: Colors.red),<br>      onPressed: () => _onValidatePressed(<br>        context,<br>        logbook.id,<br>        'rejected',<br>      ),<br>    ),<br>  ],<br>)``` |

Saat halaman ini diakses oleh dosen pembimbing maupun guru pamong, sistem akan mengambil data logbook dari mahasiswa yang dibimbing melalui API endpoint `/logbooks/validasi` dan menyimpannya dalam reactive list menggunakan controller. State management menggunakan `Obx()` untuk menampilkan loading indicator, error message, atau empty state sesuai kondisi. Setiap logbook ditampilkan dalam Card dengan dua tombol aksi: approve (ikon centang hijau) dan reject (ikon silang merah). Saat tombol validasi diklik, akan muncul dialog konfirmasi terlebih dahulu. Setelah dikonfirmasi, method `controller.validateLogbook(id, action)` akan dipanggil yang mengirim data ke backend melalui service `LogbookService.updateValidationStatus()` dengan method PUT ke endpoint `/logbooks/validasi/{id}`.

![Tampilan halaman validasi logbook](path/to/validasi-screenshot.png)

---

### Fitur Input Data Akademik (Buat Akun)

| No | Kode |
|----|------|
| 12 | ```dart<br>final controller = Get.put(BuatakunController());``` |
| 25-30 | ```dart<br>TextFormField(<br>  onChanged: (value) {<br>    controller.name.value = value;<br>  },<br>  decoration: _inputDecoration("Masukkan nama"),<br>)``` |
| 36-42 | ```dart<br>TextFormField(<br>  onChanged: (value) {<br>    controller.email.value = value;<br>  },<br>  keyboardType: TextInputType.emailAddress,<br>  decoration: _inputDecoration("Masukkan email"),<br>)``` |
| 75-88 | ```dart<br>DropdownButtonFormField<String>(<br>  value: controller.selectedRole.value,<br>  items: controller.roleOptions.map((role) {<br>    return DropdownMenuItem<String>(<br>      value: role,<br>      child: Text(role),<br>    );<br>  }).toList(),<br>  onChanged: (val) {<br>    controller.selectedRole.value = val!;<br>  },<br>  decoration: _dropdownDecoration(),<br>)``` |
| 147-155 | ```dart<br>CustomButton(<br>  text: "BUAT AKUN",<br>  color: Colors.green,<br>  shadowColor: Colors.green.shade700,<br>  onTap: controller.submitBuatAkun,<br>  isPressed: controller.isSubmitting.value,<br>)``` |

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
