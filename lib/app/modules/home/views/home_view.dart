import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/app/routes/app_pages.dart';
import 'package:plp/widget/animation/latar_belakang_home_widget.dart';
import 'package:plp/widget/custom_button.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.namaAkun.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 10,
                      color: Color(0x55000000),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                controller.emailAkun.value,
                style: const TextStyle(
                  color: Color(0xFFF5F7FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 10,
                      color: Color(0x55000000),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const LatarBelakangHomeWidget(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 500),
              child: Column(
                children: [
                  const Spacer(),
                  Obx(
                    () =>
                        controller.roleAkun.value == 'Mahasiswa'
                            ? SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                text: 'DAFTAR UJIAN PLP',
                                color: const Color(0xFF7E57C2),
                                shadowColor: const Color(0xFF5E35B1),
                                onTap: () => Get.toNamed(Routes.DAFTARUJIANPLP),
                                isPressed: false,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavbar(),
    );
  }
}
