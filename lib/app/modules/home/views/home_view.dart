import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/app/routes/app_pages.dart';
import 'package:plp/widget/custom_button.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.namaAkun.value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                controller.emailAkun.value,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 3, color: Color(0xFFE5E7EB)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.93,
              child: Transform.translate(
                offset: const Offset(25, 0),
                child: Image.asset(
                  'assets/images/neko_pusing.png',
                  width: 400,
                  height: 400,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomButton(
              text: 'DAFTAR UJIAN PLP',
              color: const Color(0xFF7E57C2),
              shadowColor: const Color(0xFF5E35B1),
              onTap: () => Get.toNamed(Routes.DAFTARUJIANPLP),
              isPressed: false,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: const CustomNavbar(),
    );
  }
}
