# 📋 LAPORAN PRAKTEK KERJA LAPANGAN (PKL)
## Aplikasi PLP (Praktik Lapangan Pembekalan)

---

## 📌 INFORMASI UMUM

**Nama Aplikasi:** PLP (Praktik Lapangan Pembekalan)  
**Platform:** Flutter (Cross-platform: Android & iOS)  
**Bahasa Pemrograman:** Dart  
**State Management:** GetX  
**Backend:** REST API (Laravel/PHP)  
**Database:** MySQL

---

## 🎯 DESKRIPSI APLIKASI

Aplikasi PLP adalah platform manajemen praktik lapangan yang dirancang untuk memfasilitasi:
- Pendaftaran mahasiswa untuk program PLP (Praktik Lapangan Pembekalan)
- Penempatan di Sekolah Menengah Kejuruan (SMK)
- Pencatatan aktivitas harian melalui logbook
- Validasi logbook oleh guru dan dosen pembimbing
- Manajemen data pengguna (Mahasiswa, Dosen, Guru, Admin, Koordinator)
- Sistem otentikasi berbasis email institusional (@ub.ac.id)

---

## 🏗️ ARSITEKTUR APLIKASI

### **Struktur Folder Project:**
```
lib/
├── main.dart                           # Entry point aplikasi
├── app/
│   ├── routes/
│   │   ├── app_pages.dart            # Routing configuration
│   │   └── app_routes.dart           # Route definitions
│   ├── modules/                      # Feature modules
│   │   ├── login/
│   │   ├── buatakun/
│   │   ├── home/
│   │   ├── pendaftaranplp/
│   │   ├── isilogbook/
│   │   ├── validasilogbook/
│   │   ├── lihatdataplpall/
│   │   ├── createprofile/
│   │   ├── lupapassword/
│   │   ├── gantipassword/
│   │   ├── formlogbook/
│   │   ├── gurupamong/
│   │   ├── keminatan/
│   │   ├── smk/
│   │   ├── otp/
│   │   └── [modul lainnya]
│   └── navbar/
│       └── custom_navbar.dart         # Bottom navigation bar
├── models/                            # Data models
│   ├── user_model.dart
│   ├── auth_response_model.dart
│   ├── pendaftaranplp_model.dart
│   ├── logbook_model.dart
│   ├── smk_model.dart
│   ├── keminatan_model.dart
│   └── [model lainnya]
├── service/                           # API services
│   ├── auth_service.dart
│   ├── pendaftaran_plp_service.dart
│   ├── logbook_service.dart
│   ├── guru_service.dart
│   ├── akun_service.dart
│   └── [service lainnya]
├── widget/                            # Custom widgets
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   └── [widget lainnya]
└── config/
    └── email_config.dart              # Email configuration
```

---

## ✨ FITUR UTAMA APLIKASI

### **1. 🔐 AUTENTIKASI & AKUN**

#### **Fitur: Login**
- **Deskripsi:** Pengguna dapat login menggunakan email institusional (@ub.ac.id) dan password
- **File Penting:**
  - `lib/app/modules/login/controllers/login_controller.dart`
  - `lib/app/modules/login/views/login_view.dart`
  - `lib/service/auth_service.dart`

**Code Penting - Login Controller:**
```dart
// lib/app/modules/login/controllers/login_controller.dart
Future<void> login() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  // Validasi email domain
  if (!email.endsWith('.ub.ac.id')) {
    Get.snackbar("Error", "Hanya email dengan domain .ub.ac.id yang diperbolehkan!");
    return;
  }

  isLoginPressed.value = true;
  try {
    final response = await AuthService.login(
      email: email,
      password: password,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final result = SimpleLoginResponse.fromJson(jsonResponse);

      // Simpan token dan user data
      box.write('token', result.token);
      box.write('user', {
        'id': result.id,
        'name': jsonResponse['name'] ?? '',
        'email': result.email,
        'role': jsonResponse['role'] ?? 'Observer',
      });

      Get.snackbar("Berhasil", result.status);
      Get.toNamed('/home');
    }
  } catch (e) {
    Get.snackbar("Error", "Terjadi kesalahan: $e");
  } finally {
    isLoginPressed.value = false;
  }
}
```

**Code Penting - Auth Service:**
```dart
// lib/service/auth_service.dart
static Future<http.Response> login({
  required String email,
  required String password,
}) {
  final url = Uri.parse('$baseUrl/login');
  return http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({"email": email, "password": password}),
  );
}
```

#### **Fitur: Buat Akun**
- **Deskripsi:** Admin dapat membuat akun pengguna baru dengan role berbeda
- **File Penting:**
  - `lib/app/modules/buatakun/controllers/buatakun_controller.dart`
  - `lib/app/modules/buatakun/views/buatakun_view.dart`
  - `lib/service/akun_service.dart`

**Code Penting - Buat Akun Controller:**
```dart
// lib/app/modules/buatakun/controllers/buatakun_controller.dart
Future<void> submitBuatAkun() async {
  if (!isFormValid) {
    Get.snackbar("Validasi", "Mohon lengkapi semua field yang diperlukan");
    return;
  }

  if (password.value != passwordConfirmation.value) {
    Get.snackbar("Validasi", "Password dan konfirmasi password tidak sama");
    return;
  }

  isSubmitting.value = true;
  try {
    final result = await AkunService.createAccount(
      name: name.value,
      email: email.value,
      password: password.value,
      passwordConfirmation: passwordConfirmation.value,
      role: selectedRole.value,
      details: details.value.isNotEmpty ? details.value : null,
    );

    Get.snackbar("Sukses", "Akun berhasil dibuat!");
    resetForm();
    await Future.delayed(const Duration(milliseconds: 700));
    Get.back();
  } catch (e) {
    Get.snackbar("Error", "Gagal membuat akun:\n${e.toString()}");
  } finally {
    isSubmitting.value = false;
  }
}
```

#### **Fitur: Lupa Password & Ganti Password**
- **Deskripsi:** Pengguna dapat mereset password melalui email dan mengubah password
- **File Penting:**
  - `lib/app/modules/lupapassword/controllers/lupapassword_controller.dart`
  - `lib/app/modules/gantipassword/controllers/gantipassword_controller.dart`
  - `lib/service/auth_service.dart`

---

### **2. 📝 PENDAFTARAN PLP**

#### **Fitur: Pendaftaran PLP**
- **Deskripsi:** Mahasiswa dapat mendaftar program PLP dengan memilih:
  - Keminatan (jurusan)
  - Nilai PLP 1 dan Micro Teaching
  - Dua pilihan SMK sebagai tempat PLP
- **File Penting:**
  - `lib/app/modules/pendaftaranplp/controllers/pendaftaranplp_controller.dart`
  - `lib/app/modules/pendaftaranplp/views/pendaftaranplp_view.dart`
  - `lib/service/pendaftaran_plp_service.dart`

**Code Penting - Pendaftaran PLP Controller:**
```dart
// lib/app/modules/pendaftaranplp/controllers/pendaftaranplp_controller.dart
@override
void onInit() {
  super.onInit();
  fetchDropdownData();
  cekStatusPendaftaran();
}

// Mengambil data dropdown keminatan dan SMK
Future<void> fetchDropdownData() async {
  try {
    final keminatans = await KeminatanService.getKeminatan();
    keminatanList.assignAll(keminatans);

    final smks = await SmkService.getSmks();
    smkList.assignAll(smks);
  } catch (e) {
    Get.snackbar("Error", "Gagal memuat data dropdown:\n${e.toString()}");
  }
}

// Mengirim data pendaftaran
void submitPendaftaran() async {
  isSubmitting.value = true;

  // Validasi input
  if (selectedKeminatanId.value == null) {
    Get.snackbar("Error", "Keminatan belum dipilih.");
    isSubmitting.value = false;
    return;
  }

  if (selectedSmk1Id.value == null || selectedSmk2Id.value == null) {
    Get.snackbar("Error", "Silakan pilih dua SMK.");
    isSubmitting.value = false;
    return;
  }

  try {
    final pendaftaran = await PendaftaranPlpService.submitPendaftaranPlp(
      keminatanId: selectedKeminatanId.value!,
      nilaiPlp1: selectedNilaiPlp1.value,
      nilaiMicroTeaching: selectedNilaiMicro.value,
      pilihanSmk1: selectedSmk1Id.value!,
      pilihanSmk2: selectedSmk2Id.value!,
    );

    Get.snackbar("Sukses", "Pendaftaran berhasil dengan ID ${pendaftaran.id}");
    Get.offAllNamed(Routes.HOME);
  } catch (e) {
    Get.snackbar("Gagal", "Pendaftaran gagal:\n${e.toString()}");
  } finally {
    isSubmitting.value = false;
  }
}
```

**Code Penting - Pendaftaran PLP Service:**
```dart
// lib/service/pendaftaran_plp_service.dart
static Future<PendaftaranPlpModel> submitPendaftaranPlp({
  required int keminatanId,
  required String nilaiPlp1,
  required String nilaiMicroTeaching,
  required int pilihanSmk1,
  required int pilihanSmk2,
}) async {
  final token = getToken();
  if (token == null) throw Exception("Token tidak ditemukan.");

  final response = await http.post(
    Uri.parse("$_baseUrl/pendaftaran-plp"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'keminatan_id': keminatanId,
      'nilai_plp_1': nilaiPlp1,
      'nilai_micro_teaching': nilaiMicroTeaching,
      'pilihan_smk_1': pilihanSmk1,
      'pilihan_smk_2': pilihanSmk2,
    }),
  );

  final json = jsonDecode(response.body);
  final isSuccess = response.statusCode == 200 || response.statusCode == 201;

  if (isSuccess) {
    final data = json['data'] ?? json['pendaftaran_plp'];
    if (data != null) {
      return PendaftaranPlpModel.fromJson(data);
    }
  }

  throw Exception(json['message'] ?? 'Gagal mendaftar PLP.');
}
```

#### **Fitur: Cek Status Pendaftaran**
- **Deskripsi:** Sistem mengecek apakah mahasiswa sudah terdaftar
- **File Penting:** `lib/service/pendaftaran_plp_service.dart`

**Code Penting:**
```dart
// lib/service/pendaftaran_plp_service.dart
static Future<bool> cekSudahDaftar() async {
  final token = getToken();
  if (token == null) throw Exception("Token tidak ditemukan.");

  final response = await http.get(
    Uri.parse("$_baseUrl/pendaftaran-plp"),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final decoded = jsonDecode(response.body);
    return decoded is List && decoded.isNotEmpty;
  } else {
    throw Exception("Gagal mengecek status pendaftaran.");
  }
}
```

---

### **3. 📚 LOGBOOK**

#### **Fitur: Isi Logbook**
- **Deskripsi:** Mahasiswa mencatat aktivitas harian selama PLP
  - Tanggal kegiatan
  - Keterangan aktivitas
  - Waktu mulai dan selesai
  - Dokumentasi/bukti
- **File Penting:**
  - `lib/app/modules/isilogbook/controllers/isilogbook_controller.dart`
  - `lib/app/modules/formlogbook/controllers/formlogbook_controller.dart`
  - `lib/service/logbook_service.dart`

**Code Penting - Isi Logbook Controller:**
```dart
// lib/app/modules/isilogbook/controllers/isilogbook_controller.dart
@override
void onInit() {
  super.onInit();
  fetchLogbookData();
}

Future<void> fetchLogbookData() async {
  isLoading.value = true;
  try {
    final data = await LogbookService.getLogbooks();
    logbookList.assignAll(data);
  } catch (e) {
    Get.snackbar("Error", "Gagal memuat data logbook: $e");
  } finally {
    isLoading.value = false;
  }
}

// Navigasi ke form tambah logbook
void goToTambahLogbook() async {
  Get.lazyPut(() => FormlogbookController());
  final result = await Get.to(() => const FormlogbookView());
  if (result == true) {
    fetchLogbookData();
  }
}

// Hapus logbook
Future<void> deleteLogbook(int id) async {
  try {
    await LogbookService.deleteLogbook(id);
    logbookList.removeWhere((l) => l.id == id);
    Get.snackbar("Sukses", "Logbook berhasil dihapus");
  } catch (e) {
    Get.snackbar("Error", "Gagal menghapus logbook: $e");
  }
}

// Hitung durasi kegiatan
String calculateDuration(String mulai, String selesai) {
  final start = DateFormat("HH:mm:ss").parse(mulai);
  final end = DateFormat("HH:mm:ss").parse(selesai);
  final durasiJam = end.difference(start).inHours;
  final durasiMenit = end.difference(start).inMinutes % 60;
  return durasiMenit == 0
      ? "$durasiJam jam"
      : "$durasiJam jam $durasiMenit menit";
}
```

**Code Penting - Logbook Service (CRUD):**
```dart
// lib/service/logbook_service.dart

// READ - Ambil semua logbook
static Future<List<LogbookModel>> getLogbooks() async {
  final token = box.read('token');
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => LogbookModel.fromJson(e)).toList();
  } else {
    throw Exception('Gagal memuat logbook');
  }
}

// CREATE - Tambah logbook baru
static Future<void> createLogbookRaw({
  required String tanggal,
  required String keterangan,
  required String mulai,
  required String selesai,
  required String dokumentasi,
}) async {
  final token = box.read('token');
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'tanggal': tanggal,
      'keterangan': keterangan,
      'mulai': mulai,
      'selesai': selesai,
      'dokumentasi': dokumentasi,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    final data = jsonDecode(response.body);
    throw Exception(data['message'] ?? 'Gagal menambahkan logbook');
  }
}

// UPDATE - Edit logbook
static Future<void> updateLogbook(
  int id, {
  required String tanggal,
  required String keterangan,
  required String mulai,
  required String selesai,
  required String dokumentasi,
}) async {
  final token = box.read('token');
  final response = await http.put(
    Uri.parse('$baseUrl/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'tanggal': tanggal,
      'keterangan': keterangan,
      'mulai': mulai,
      'selesai': selesai,
      'dokumentasi': dokumentasi,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Gagal memperbarui logbook');
  }
}

// DELETE - Hapus logbook
static Future<void> deleteLogbook(int id) async {
  final token = box.read('token');
  final response = await http.delete(
    Uri.parse('$baseUrl/$id'),
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus logbook');
  }
}
```

#### **Fitur: Validasi Logbook**
- **Deskripsi:** Guru pamong dan dosen pembimbing dapat memvalidasi logbook yang diisi mahasiswa
- **File Penting:**
  - `lib/app/modules/validasilogbook/controllers/validasilogbook_controller.dart`
  - `lib/app/modules/validasilogbook/views/validasilogbook_view.dart`
  - `lib/service/logbook_service.dart`

**Code Penting - Validasi Logbook Controller:**
```dart
// lib/app/modules/validasilogbook/controllers/validasilogbook_controller.dart
@override
void onInit() {
  super.onInit();
  fetchLogbooksValidasi();
}

Future<void> fetchLogbooksValidasi() async {
  try {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await LogbookService.getLogbooksForValidation();

    if (result.isEmpty) {
      errorMessage.value = 'Tidak ada logbook untuk divalidasi.';
    }
    logbooks.value = result;
  } catch (e) {
    errorMessage.value = 'Gagal memuat data logbook: $e';
    logbooks.clear();
  } finally {
    isLoading.value = false;
  }
}

// Validasi logbook dengan status (Terima/Tolak)
Future<bool> validateLogbook(int id, String status) async {
  try {
    final success = await LogbookService.updateValidationStatus(id, status);
    if (success) {
      await fetchLogbooksValidasi();
      return true;
    }
    return false;
  } catch (e) {
    errorMessage.value = 'Gagal validasi logbook: $e';
    return false;
  }
}
```

---

### **4. 🏫 PENEMPATAN & PENUGASAN**

#### **Fitur: Lihat Data Pendaftaran PLP (Koordinator)**
- **Deskripsi:** Koordinator dapat melihat semua data pendaftaran dan melakukan penempatan
- **File Penting:**
  - `lib/app/modules/lihatdataplpall/controllers/lihatdataplpall_controller.dart`
  - `lib/app/modules/lihatdataplpall/views/lihatdataplpall_view.dart`

#### **Fitur: Assign Penempatan, Dosen Pembimbing, & Guru Pamong**
- **Deskripsi:** Koordinator dapat menugaskan SMK, dosen pembimbing, dan guru pamong ke mahasiswa
- **File Penting:**
  - `lib/app/modules/lihatdataplpall/controllers/lihatdataplpall_controller.dart`
  - `lib/service/pendaftaran_plp_service.dart`

**Code Penting - Assign Penempatan:**
```dart
// lib/app/modules/lihatdataplpall/controllers/lihatdataplpall_controller.dart
Future<void> assignPenempatanDanDospem({
  required int pendaftaranId,
  required int idSmk,
  required int idDospem,
  required int idGuruPamong,
}) async {
  isAssigning.value = true;
  try {
    await PendaftaranPlpService.assignPenempatanDospem(
      pendaftaranId: pendaftaranId,
      idSmk: idSmk,
      idDospem: idDospem,
      idGuruPamong: idGuruPamong,
    );

    // Update data lokal
    final registrationIndex = pendaftaranList.indexWhere(
      (item) => item.id == pendaftaranId,
    );
    if (registrationIndex != -1) {
      final currentRegistration = pendaftaranList[registrationIndex];
      final updatedRegistration = PendaftaranPlpModel(
        id: currentRegistration.id,
        userId: currentRegistration.userId,
        keminatanId: currentRegistration.keminatanId,
        nilaiPlp1: currentRegistration.nilaiPlp1,
        nilaiMicroTeaching: currentRegistration.nilaiMicroTeaching,
        pilihanSmk1: currentRegistration.pilihanSmk1,
        pilihanSmk2: currentRegistration.pilihanSmk2,
        penempatan: idSmk,
        dosenPembimbing: idDospem,
        guruPamong: idGuruPamong,
        createdAt: currentRegistration.createdAt,
        updatedAt: currentRegistration.updatedAt,
      );

      pendaftaranList[registrationIndex] = updatedRegistration;
      Get.snackbar(
        "Sukses",
        "Berhasil meng-assign:\n• SMK: ${getNamaSmk(idSmk)}\n• Dosen: ${getNamaDospem(idDospem)}\n• Guru: ${getNamaGuruPamong(idGuruPamong)}",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Gagal meng-assign:\n${e.toString()}",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isAssigning.value = false;
  }
}
```

**Code Penting - Assign Service:**
```dart
// lib/service/pendaftaran_plp_service.dart
static Future<void> assignPenempatanDospem({
  required int pendaftaranId,
  required int idSmk,
  required int idDospem,
  int? idGuruPamong,
}) async {
  final token = getToken();
  if (token == null) throw Exception("Token tidak ditemukan.");

  final requestBody = {
    "penempatan": idSmk,
    "dosen_pembimbing": idDospem,
    "guru_pamong": idGuruPamong,
  };

  final response = await http.patch(
    Uri.parse("$_baseUrl/pendaftaran-plp/$pendaftaranId"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(requestBody),
  );

  final json = jsonDecode(response.body);

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    print('✅ Assignment successful');
    return;
  } else {
    final message = json['message'] ?? '';
    if (message.toLowerCase().contains('berhasil')) {
      return;
    }
    throw Exception(json['message'] ?? 'Gagal assign penempatan/dospem');
  }
}
```

---

### **5. 👥 MANAJEMEN MASTER DATA**

#### **Fitur: Data SMK**
- **Deskripsi:** Kelola data sekolah menengah kejuruan yang menjadi tempat PLP
- **File Penting:** `lib/app/modules/smk/controllers/smk_controller.dart`
- **Service:** `lib/service/smk_service.dart`

#### **Fitur: Data Keminatan**
- **Deskripsi:** Kelola data keminatan/jurusan yang tersedia
- **File Penting:** `lib/app/modules/keminatan/controllers/keminatan_controller.dart`
- **Service:** `lib/service/keminatan_service.dart`

#### **Fitur: Data Guru Pamong**
- **Deskripsi:** Kelola data guru pembimbing di SMK
- **File Penting:** `lib/app/modules/gurupamong/controllers/gurupamong_controller.dart`
- **Service:** `lib/service/guru_service.dart`

**Code Penting - Guru Service:**
```dart
// lib/service/guru_service.dart
class GuruPamongService {
  static final box = GetStorage();
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Map<String, dynamic>>> getAllGuruPamong() async {
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('$baseUrl/akun/pamong'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> users = decoded['users'];
      return users.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal mengambil data Guru Pamong');
    }
  }
}
```

---

### **6. 🔐 KEAMANAN**

#### **Fitur: Token-Based Authentication**
- **Deskripsi:** Setiap request dilengkapi dengan Bearer token untuk keamanan
- **File Penting:** Semua service files menggunakan token dari GetStorage

**Code Pattern untuk Token:**
```dart
// Di setiap service, ambil token seperti ini:
static String? getToken() {
  final box = GetStorage();
  return box.read("token");
}

// Gunakan dalam header request:
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
  'Accept': 'application/json',
}
```

#### **Fitur: Email Domain Validation**
- **Deskripsi:** Hanya email dengan domain @ub.ac.id yang diperbolehkan login
- **File Penting:** `lib/app/modules/login/controllers/login_controller.dart`

---

## 📊 DATA MODELS

### **User Model**
```dart
// lib/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}
```

### **Pendaftaran PLP Model**
```dart
// lib/models/pendaftaranplp_model.dart
class PendaftaranPlpModel {
  final int id;
  final int userId;
  final int keminatanId;
  final String nilaiPlp1;
  final String nilaiMicroTeaching;
  final int pilihanSmk1;
  final int pilihanSmk2;
  final int? penempatan;
  final int? dosenPembimbing;
  final int? guruPamong;
  final String? createdAt;
  final String? updatedAt;

  PendaftaranPlpModel({
    required this.id,
    required this.userId,
    required this.keminatanId,
    required this.nilaiPlp1,
    required this.nilaiMicroTeaching,
    required this.pilihanSmk1,
    required this.pilihanSmk2,
    this.penempatan,
    this.dosenPembimbing,
    this.guruPamong,
    this.createdAt,
    this.updatedAt,
  });

  factory PendaftaranPlpModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranPlpModel(
      id: json['id'],
      userId: json['user_id'],
      keminatanId: json['keminatan_id'],
      nilaiPlp1: json['nilai_plp_1'],
      nilaiMicroTeaching: json['nilai_micro_teaching'],
      pilihanSmk1: json['pilihan_smk_1'],
      pilihanSmk2: json['pilihan_smk_2'],
      penempatan: json['penempatan'],
      dosenPembimbing: json['dosen_pembimbing'],
      guruPamong: json['guru_pamong'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
```

### **Logbook Model**
```dart
// lib/models/logbook_model.dart
class LogbookModel {
  final int id;
  final String tanggal;
  final String keterangan;
  final String mulai;
  final String selesai;
  final String dokumentasi;
  final String? status; // Untuk validasi (Terima/Tolak)

  LogbookModel({
    required this.id,
    required this.tanggal,
    required this.keterangan,
    required this.mulai,
    required this.selesai,
    required this.dokumentasi,
    this.status,
  });

  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    return LogbookModel(
      id: json['id'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      mulai: json['mulai'],
      selesai: json['selesai'],
      dokumentasi: json['dokumentasi'],
      status: json['status'],
    );
  }
}
```

---

## 🛠️ TEKNOLOGI & LIBRARY YANG DIGUNAKAN

| Library | Versi | Fungsi |
|---------|-------|--------|
| **flutter** | 3.7.0 | Framework utama |
| **get** | 4.7.2 | State management & routing |
| **http** | 1.3.0 | HTTP client untuk API |
| **get_storage** | 2.1.1 | Local storage (token, user data) |
| **logger** | 2.0.2 | Logging untuk debugging |
| **intl** | 0.20.2 | Date/time formatting |
| **mailer** | 6.5.0 | Email service |

---

## 🔗 API ENDPOINTS

### **Authentication**
- `POST /api/register` - Register pengguna baru
- `POST /api/login` - Login pengguna
- `POST /api/forgot-password` - Request reset password

### **Pendaftaran PLP**
- `GET /api/pendaftaran-plp` - Ambil data pendaftaran user
- `POST /api/pendaftaran-plp` - Submit pendaftaran baru
- `PATCH /api/pendaftaran-plp/{id}` - Assign penempatan/dospem
- `GET /api/pendaftaran-plp/all` - Ambil semua pendaftaran (Koordinator)

### **Logbook**
- `GET /api/logbooks` - Ambil semua logbook user
- `POST /api/logbooks` - Tambah logbook baru
- `PUT /api/logbooks/{id}` - Edit logbook
- `DELETE /api/logbooks/{id}` - Hapus logbook
- `GET /api/logbooks/validasi` - Ambil logbook untuk validasi
- `PUT /api/logbooks/validasi/{id}` - Validasi logbook

### **Master Data**
- `GET /api/smks` - Ambil data SMK
- `GET /api/keminatan` - Ambil data keminatan
- `GET /api/akun/pamong` - Ambil data guru pamong

---

## 🎨 STRUKTUR UI/UX

### **Bottom Navigation Bar**
```dart
// lib/app/navbar/custom_navbar.dart
- Home
- Pendaftaran
- Logbook
- Selengkapnya (Menu lainnya)
```

### **Halaman Utama**
1. **Login** - Form login dengan validasi email domain
2. **Home** - Dashboard utama
3. **Pendaftaran PLP** - Form pendaftaran dengan dropdown
4. **Isi Logbook** - List dan form logbook
5. **Validasi Logbook** - List logbook untuk divalidasi
6. **Lihat Data PLP (All)** - Admin/Koordinator view
7. **Lupa Password** - Form reset password

---

## 🔄 FLOW APLIKASI

### **Flow Pendaftaran Mahasiswa**
```
Login (Email @ub.ac.id)
    ↓
Home Dashboard
    ↓
Pendaftaran PLP (Pilih Keminatan & 2 SMK)
    ↓
Submit Pendaftaran
    ↓
Status Pendaftaran Selesai
    ↓
Mulai Isi Logbook Harian
```

### **Flow Validasi Logbook**
```
Mahasiswa: Isi Logbook Harian
    ↓
Guru Pamong/Dosen: Lihat Logbook di Menu Validasi
    ↓
Guru Pamong/Dosen: Klik Terima/Tolak
    ↓
Logbook Status Berubah
```

### **Flow Penempatan (Koordinator)**
```
Koordinator: Lihat Semua Pendaftaran (All)
    ↓
Koordinator: Pilih Mahasiswa
    ↓
Koordinator: Assign SMK, Dosen Pembimbing, Guru Pamong
    ↓
Penempatan Selesai
```

---

## 📱 FITUR TAMBAHAN

### **Custom Widgets**
- `CustomButton` - Tombol reusable dengan styling konsisten
- `CustomTextField` - Input field dengan validasi
- `RoundedMenuitem` - Menu item dengan design rounded

### **State Management (GetX)**
- Reactive variables dengan `.obs`
- Observable list dengan `<T>[].obs`
- Get.put() - Dependency injection
- Get.snackbar() - Notification UI

---

## 🚀 DEPLOYMENT

### **Build APK Android**
```bash
flutter build apk --release
```

### **Build IOS**
```bash
flutter build ios --release
```

---

## 📝 CATATAN PENTING

1. **Server Base URL:** `http://10.0.2.2:8000/api`
   - Untuk emulator, gunakan IP address `10.0.2.2` (host machine)
   - Untuk device fisik, ganti dengan IP address server

2. **Token Storage:**
   - Token disimpan di `GetStorage` (local storage)
   - Setiap request harus include token di header Authorization

3. **Email Domain:**
   - Hanya email dengan domain `.ub.ac.id` yang diperbolehkan login

4. **Validasi Logbook:**
   - Status logbook bisa: Pending, Terima, Tolak
   - Guru dan Dosen Pembimbing bisa melakukan validasi

---

## 📚 DOKUMENTASI KODE

Setiap fitur memiliki dokumentasi lengkap dengan:
- ✅ Controller logic
- ✅ Service API calls
- ✅ Data models
- ✅ UI/View implementation
- ✅ State management dengan GetX

---

## 🎓 KESIMPULAN

Aplikasi PLP adalah sistem manajemen praktik lapangan yang komprehensif dengan fitur:
- ✅ Autentikasi & manajemen akun
- ✅ Pendaftaran PLP dengan penempatan
- ✅ Pencatatan logbook harian
- ✅ Validasi oleh guru/dosen
- ✅ Dashboard koordinator untuk pengelolaan
- ✅ Architecture clean dengan GetX pattern

Semua kode mengikuti best practices Flutter development dengan struktur terorganisir dan mudah dimaintain.

---

**Laporan ini dibuat sebagai dokumentasi Praktek Kerja Lapangan (PKL)**

**Tanggal:** 20 November 2025  
**Platform:** Flutter & REST API  
**Version:** 1.0.0

