import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/navbar_popup_helper.dart';
import 'navbar_controller.dart';

class CustomNavbar extends StatelessWidget {
  final NavbarController controller = Get.put(NavbarController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 30),
            BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: (index) {
                if (index == 0) {
                  // 👉 Navigasi ke halaman Home
                  Get.toNamed('/home');
                } else if (index == 1) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder:
                        (_) => Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child:
                              controller.role.value == 'Mahasiswa' ||
                                      controller.role.value == 'Observer'
                                  ? LogbookBottomSheet(controller.role.value)
                                  : const AdminLogbookValidationSheet(),
                        ),
                  );
                } else if (index == 2) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder:
                        (_) => Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child:
                              controller.role.value == 'Mahasiswa'
                                  ? const MahasiswaPendaftaranSheet()
                                  : controller.role.value == 'Observer'
                                  ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          "Akses Terbatas: Anda masuk sebagai observer.",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : const AdminLihatKelengkapanSheet(),
                        ),
                  );
                } else if (index == 3) {
                  // 👉 Navigasi ke halaman Selengkapnya
                  Get.toNamed('/selengkapnya');
                } else {
                  controller.onTabTapped(index);
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/home.png',
                    width: 40,
                    height: 40,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/logbook.png',
                    width: 40,
                    height: 40,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/pendaftaran.png',
                    width: 40,
                    height: 40,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/selengkapnya.png',
                    width: 40,
                    height: 40,
                  ),
                  label: '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
