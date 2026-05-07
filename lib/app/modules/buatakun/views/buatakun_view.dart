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
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Buat Akun'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Informasi Akun',
                subtitle: 'Lengkapi data akun utama terlebih dahulu',
                icon: Icons.person_add_alt_1_rounded,
                children: [
                  _buildFieldLabel('Nama'),
                  const SizedBox(height: 8),
                  TextFormField(
                    onChanged: (value) {
                      controller.name.value = value;
                    },
                    decoration: _inputDecoration(
                      'Masukkan nama',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFieldLabel('Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    onChanged: (value) {
                      controller.email.value = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      'Masukkan email',
                      prefixIcon: Icons.alternate_email_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFieldLabel('Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    onChanged: (value) {
                      controller.password.value = value;
                    },
                    obscureText: true,
                    decoration: _inputDecoration(
                      'Masukkan password',
                      prefixIcon: Icons.lock_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFieldLabel('Konfirmasi Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    onChanged: (value) {
                      controller.passwordConfirmation.value = value;
                    },
                    obscureText: true,
                    decoration: _inputDecoration(
                      'Konfirmasi password',
                      prefixIcon: Icons.lock_reset_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFieldLabel('Role'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: controller.selectedRole.value,
                    isExpanded: true,
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
                    decoration: _dropdownDecoration(
                      prefixIcon: Icons.badge_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Detail Tambahan (Opsional)',
                subtitle: 'Tambahkan detail seperti NIK, TTL, dan lainnya',
                icon: Icons.note_alt_outlined,
                children: [
                  if (controller.details.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Text(
                        'Belum ada detail tambahan. Tap tombol di bawah untuk menambah field.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ...controller.details.entries.map(
                    (entry) => _buildDetailField(
                      fieldKey: entry.key,
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final key = "detail_${controller.details.length + 1}";
                        controller.addDetail(key, "");
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text("Tambah Detail"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
      bottomNavigationBar: const CustomNavbar(),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildDetailField({
    required String fieldKey,
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
                  initialValue: fieldKey,
                  onChanged: onKeyChanged,
                  decoration: _inputDecoration(
                    "Nama Field",
                    prefixIcon: Icons.drive_file_rename_outline,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            onChanged: onValueChanged,
            decoration: _inputDecoration(
              "Nilai",
              prefixIcon: Icons.edit_note_rounded,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon:
          prefixIcon != null
              ? Icon(prefixIcon, color: const Color(0xFF9CA3AF), size: 20)
              : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.2),
      ),
    );
  }

  InputDecoration _dropdownDecoration({IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon:
          prefixIcon != null
              ? Icon(prefixIcon, color: const Color(0xFF9CA3AF), size: 20)
              : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.2),
      ),
    );
  }
}
