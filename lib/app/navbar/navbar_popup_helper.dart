import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/navbar_controller.dart';

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
        ],
      ),
    );
  }
}

class AdminLogbookValidationSheet extends StatelessWidget {
  const AdminLogbookValidationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil role dari NavbarController
    final role = Get.find<NavbarController>().role.value;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Validasi logbook hanya untuk Dosen Pembimbing dan Guru
          if (role != 'Kaprodi' &&
              role != 'Akademik' &&
              role != 'Dosen Koordinator')
            ListTile(
              leading: const Icon(
                Icons.verified,
                color: Colors.green,
                size: 28,
              ),
              title: const Text(
                "Validasi Logbook",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/validasilogbook');
              },
            ),
          // Divider hanya jika menu Validasi Logbook tampil
          if (role != 'Kaprodi' &&
              role != 'Akademik' &&
              role != 'Dosen Koordinator')
            const Divider(),
          // Hanya tampilkan untuk role yang memang boleh melihat semua logbook mahasiswa
          if (role != 'Dosen Pembimbing' && role != 'Guru')
            ListTile(
              leading: const Icon(
                Icons.remove_red_eye,
                color: Colors.blue,
                size: 28,
              ),
              title: const Text(
                "Lihat Logbook Mahasiswa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/lihatlogbookall');
              },
            ),

          if (role == 'Dosen Koordinator') const Divider(),
          if (role == 'Dosen Koordinator')
            ListTile(
              leading: const Icon(
                Icons.assignment,
                color: Colors.deepOrange,
                size: 28,
              ),
              title: const Text(
                "Lihat Pelaporan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/lihatpelaporan');
              },
            ),
        ],
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
              "Pendaftaran PLP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/pendaftaranplp');
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
              Get.toNamed('/lihatdataplp');
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
    // Ambil role dari NavbarController
    final role = Get.find<NavbarController>().role.value;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hanya tampilkan jika bukan Dosen Pembimbing
          if (role != 'Dosen Pembimbing')
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
                Get.toNamed('/lihatdataplpall');
              },
            ),
        ],
      ),
    );
  }
}
