import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ==== LOGBOOK ====

class LogbookBottomSheet extends StatelessWidget {
  final String role;
  const LogbookBottomSheet(this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.orange, size: 28),
            title: const Text(
              "Pengisian Logbook",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              if (role == 'Mahasiswa') {
                Get.toNamed('/isilogbook');
              } else {
                Get.snackbar(
                  "Akses Ditolak",
                  "Hanya Mahasiswa yang dapat mengisi logbook.",
                  snackPosition: SnackPosition.TOP,
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.remove_red_eye,
              color: Colors.blue,
              size: 28,
            ),
            title: const Text(
              "Lihat Logbook",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              if (role == 'Mahasiswa' || role == 'Observer') {
                Get.toNamed('/logbook/lihat');
              } else {
                Get.snackbar(
                  "Akses Ditolak",
                  "Role Anda tidak memiliki izin untuk melihat logbook.",
                  snackPosition: SnackPosition.TOP,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class AdminLogbookValidationSheet extends StatelessWidget {
  const AdminLogbookValidationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.verified),
        title: const Text("Validasi Logbook"),
        onTap: () {
          Navigator.pop(context);
          Get.toNamed('/logbook/validasi');
        },
      ),
    );
  }
}

// ==== PENDAFTARAN ====

class MahasiswaPendaftaranSheet extends StatelessWidget {
  const MahasiswaPendaftaranSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/registrasiplp.png',
              width: 28,
              height: 28,
            ),
            title: const Text(
              "Registrasi PLP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/pendaftaran/registrasi');
            },
          ),
          const Divider(),
          ListTile(
            leading: Image.asset(
              'assets/icons/lihatkelengkapandata.png',
              width: 28,
              height: 28,
            ),
            title: const Text(
              "Lihat Kelengkapan Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/pendaftaran/kelengkapan');
            },
          ),
        ],
      ),
    );
  }
}

class AdminLihatKelengkapanSheet extends StatelessWidget {
  const AdminLihatKelengkapanSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/lihatkelengkapandata.png',
              width: 28,
              height: 28,
            ),
            title: const Text(
              "Lihat Kelengkapan Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/pendaftaran/kelengkapan');
            },
          ),
        ],
      ),
    );
  }
}
