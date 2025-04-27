import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/lihatdataplpall_controller.dart';

class LihatdataplpallView extends GetView<LihatdataplpallController> {
  const LihatdataplpallView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LihatdataplpallView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LihatdataplpallView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
