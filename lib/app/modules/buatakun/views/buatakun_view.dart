import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/app/navbar/custom_navbar.dart';
import 'package:plp/widget/custom_button.dart';
import '../controllers/buatakun_controller.dart';

class BuatakunView extends GetView<BuatakunController> {
  const BuatakunView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuatakunController());

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Nama ---
              const Text("Nama"),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  controller.name.value = value;
                },
                decoration: _inputDecoration("Masukkan nama"),
              ),
              const SizedBox(height: 12),

              /// --- Email ---
              const Text("Email"),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  controller.email.value = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Masukkan email"),
              ),
              const SizedBox(height: 12),

              /// --- Password ---
              const Text("Password"),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  controller.password.value = value;
                },
                obscureText: true,
                decoration: _inputDecoration("Masukkan password"),
              ),
              const SizedBox(height: 12),

              /// --- Konfirmasi Password ---
              const Text("Konfirmasi Password"),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  controller.passwordConfirmation.value = value;
                },
                obscureText: true,
                decoration: _inputDecoration("Konfirmasi password"),
              ),
              const SizedBox(height: 12),

              /// --- Role ---
              const Text("Role"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.selectedRole.value,
                items:
                    controller.roleOptions.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                onChanged: (val) {
                  controller.selectedRole.value = val!;
                },
                decoration: _dropdownDecoration(),
              ),
              const SizedBox(height: 24),

              /// --- Detail Fields (Optional) ---
              const Text(
                "Detail Tambahan (Opsional)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tambahkan detail tambahan seperti NIK, TTL, dll",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),

              // Dynamic detail fields
              ...controller.details.entries.map(
                (entry) => _buildDetailField(
                  key: entry.key,
                  value: entry.value,
                  onKeyChanged: (newKey) {
                    final value = controller.details[entry.key];
                    controller.removeDetail(entry.key);
                    controller.addDetail(newKey, value);
                  },
                  onValueChanged: (newValue) {
                    controller.addDetail(entry.key, newValue);
                  },
                  onRemove: () => controller.removeDetail(entry.key),
                ),
              ),

              // Add new detail field button
              OutlinedButton.icon(
                onPressed: () {
                  final key = "detail_${controller.details.length + 1}";
                  controller.addDetail(key, "");
                },
                icon: const Icon(Icons.add),
                label: const Text("Tambah Detail"),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// --- Tombol Buat Akun ---
              CustomButton(
                text: "BUAT AKUN",
                color: Colors.green,
                shadowColor: Colors.green.shade700,
                onTap: controller.submitBuatAkun,
                isPressed: controller.isSubmitting.value,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavbar(),
    );
  }

  Widget _buildDetailField({
    required String key,
    required String value,
    required Function(String) onKeyChanged,
    required Function(String) onValueChanged,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: key,
                  onChanged: onKeyChanged,
                  decoration: const InputDecoration(
                    labelText: "Nama Field",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            onChanged: onValueChanged,
            decoration: const InputDecoration(
              labelText: "Nilai",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: hint,
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
