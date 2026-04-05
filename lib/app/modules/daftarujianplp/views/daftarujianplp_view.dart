import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/daftarujianplp_controller.dart';

class DaftarujianplpView extends GetView<DaftarujianplpController> {
  const DaftarujianplpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DaftarujianplpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DaftarujianplpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
