import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();
  final token = box.read('token');
  final initialRoute =
      (token != null && token.isNotEmpty) ? Routes.HOME : Routes.ONBOARDING;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Nama Aplikasi",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
