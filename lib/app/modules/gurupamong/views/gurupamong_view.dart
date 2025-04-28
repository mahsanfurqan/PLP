import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gurupamong_controller.dart';

class GurupamongView extends GetView<GurupamongController> {
  const GurupamongView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GurupamongView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GurupamongView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
