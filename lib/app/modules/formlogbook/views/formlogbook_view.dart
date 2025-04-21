import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/formlogbook_controller.dart';

class FormlogbookView extends GetView<FormlogbookController> {
  const FormlogbookView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FormlogbookView'), centerTitle: true),
      body: const Center(
        child: Text(
          'FormlogbookView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
