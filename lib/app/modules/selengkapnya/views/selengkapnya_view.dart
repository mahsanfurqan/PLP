import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/widget/rounded_menu_item.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/app/navbar/navbar_controller.dart'; // import controller
import '../controllers/selengkapnya_controller.dart';

class SelengkapnyaView extends GetView<SelengkapnyaController> {
  const SelengkapnyaView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil role dari controller
    final role = Get.find<NavbarController>().role.value;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Tombol back
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12),
                    child: const Icon(Icons.arrow_back, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),

            // 👇 Semua role bisa lihat "Biodata"
            RoundedMenuItem(
              icon: 'assets/icons/kepalaorang.png',
              label: 'Biodata',
              onTap: () {
                Get.toNamed('/masukkan-data');
              },
            ),

            const SizedBox(height: 16),

            // 👇 Hanya non-Mahasiswa & non-Observer & non-Dosen Pembimbing yang bisa lihat 3 menu ini
            if (role != 'Mahasiswa' &&
                role != 'Observer' &&
                role != 'Dosen Pembimbing') ...[
              // Sembunyikan menu SMK jika role Admin atau Akademik
              if (role != 'Admin' && role != 'Akademik')
                RoundedMenuItem(
                  icon: 'assets/icons/smkicon.png',
                  label: 'SMK',
                  onTap: () {
                    Get.toNamed('/smk');
                  },
                ),
              if (role != 'Admin' && role != 'Akademik')
                const SizedBox(height: 16),
              RoundedMenuItem(
                icon: 'assets/icons/keminatanicon.png',
                label: 'Keminatan',
                onTap: () {
                  Get.toNamed('/keminatan');
                },
              ),
              const SizedBox(height: 16),
              RoundedMenuItem(
                icon: 'assets/icons/daftargurupamong.png',
                label: 'Daftar Guru Pamong',
                onTap: () {
                  Get.toNamed('/gurupamong');
                },
              ),
            ],

            // 👇 Hanya Akademik yang bisa lihat menu Buat Akun
            if (role == 'Akademik') ...[
              const SizedBox(height: 16),
              RoundedMenuItem(
                icon: 'assets/icons/pendaftaran.png',
                label: 'Buat Akun',
                onTap: () {
                  Get.toNamed('/buatakun');
                },
              ),
            ],
          ],
        ),
      ),

      // 👇 Navbar tetap di bawah
      bottomNavigationBar: CustomNavbar(),
    );
  }
}
