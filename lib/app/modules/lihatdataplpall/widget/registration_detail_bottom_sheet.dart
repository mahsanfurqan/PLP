import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/models/smk_model.dart';
import 'package:plp/models/user_model.dart';
import '../controllers/lihatdataplpall_controller.dart';
import 'package:collection/collection.dart';

class RegistrationDetailBottomSheet extends StatelessWidget {
  final PendaftaranPlpModel registration;
  final List<SmkModel> smkList;
  final List<UserModel> dospems;
  final List<UserModel> guruPamongs;
  final Function(int, int, int, int) onAssign;

  const RegistrationDetailBottomSheet({
    super.key,
    required this.registration,
    required this.smkList,
    required this.dospems,
    required this.guruPamongs,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    final Rxn<SmkModel> selectedSmk = Rxn<SmkModel>();
    final Rxn<UserModel> selectedDospem = Rxn<UserModel>();
    final Rxn<UserModel> selectedGuruPamong = Rxn<UserModel>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Pendaftaran',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${registration.id}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildDetailItem(
                    icon: Icons.person,
                    title: 'User ID',
                    value: registration.userId.toString(),
                    iconColor: Colors.green,
                  ),
                  _buildDetailItem(
                    icon: Icons.school,
                    title: 'Keminatan ID',
                    value: registration.keminatanId.toString(),
                    iconColor: Colors.orange,
                  ),
                  _buildDetailItem(
                    icon: Icons.grade,
                    title: 'Nilai PLP 1',
                    value: registration.nilaiPlp1,
                    iconColor: Colors.blue,
                  ),
                  _buildDetailItem(
                    icon: Icons.grade,
                    title: 'Nilai Micro Teaching',
                    value: registration.nilaiMicroTeaching,
                    iconColor: Colors.purple,
                  ),
                  _buildDetailItem(
                    icon: Icons.location_on,
                    title: 'Pilihan SMK 1',
                    value: registration.pilihanSmk1.toString(),
                    iconColor: Colors.teal,
                  ),
                  _buildDetailItem(
                    icon: Icons.location_on,
                    title: 'Pilihan SMK 2',
                    value: registration.pilihanSmk2.toString(),
                    iconColor: Colors.indigo,
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Current Assignment Section
                  const Text(
                    'Penempatan Saat Ini',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Use Obx to make it reactive to updated data
                  Obx(() {
                    // Get the latest registration data from controller
                    final controller = Get.find<LihatdataplpallController>();
                    final latestRegistration = controller.pendaftaranList
                        .firstWhereOrNull((item) => item.id == registration.id);

                    final currentRegistration =
                        latestRegistration ?? registration;

                    print(
                      '🔍 Current registration ID: ${currentRegistration.id}',
                    );
                    print('🔍 SMK: ${currentRegistration.penempatan}');
                    print('🔍 Dospem: ${currentRegistration.dosenPembimbing}');
                    print('🔍 Guru: ${currentRegistration.guruPamong}');

                    // Helper functions to get names
                    String getSmkName(int? smkId) {
                      if (smkId == null) return 'Belum di-assign';
                      try {
                        final smk = smkList.firstWhere(
                          (smk) => smk.id == smkId,
                        );
                        return smk.nama;
                      } catch (e) {
                        return 'SMK ID: $smkId';
                      }
                    }

                    String getDospemName(int? dospemId) {
                      if (dospemId == null) return 'Belum di-assign';
                      try {
                        final dospem = dospems.firstWhere(
                          (user) => user.id == dospemId,
                        );
                        return dospem.name;
                      } catch (e) {
                        return 'Dospem ID: $dospemId';
                      }
                    }

                    String getGuruName(int? guruId) {
                      if (guruId == null) return 'Belum di-assign';
                      try {
                        final guru = guruPamongs.firstWhere(
                          (user) => user.id == guruId,
                        );
                        return guru.name;
                      } catch (e) {
                        return 'Guru ID: $guruId';
                      }
                    }

                    return Column(
                      children: [
                        _buildDetailItem(
                          icon: Icons.school,
                          title: 'SMK Penempatan',
                          value: getSmkName(currentRegistration.penempatan),
                          iconColor: Colors.blue,
                        ),

                        _buildDetailItem(
                          icon: Icons.person,
                          title: 'Dosen Pembimbing',
                          value: getDospemName(
                            currentRegistration.dosenPembimbing,
                          ),
                          iconColor: Colors.green,
                        ),

                        _buildDetailItem(
                          icon: Icons.person_outline,
                          title: 'Guru Pamong',
                          value: getGuruName(currentRegistration.guruPamong),
                          iconColor: Colors.orange,
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Assignment Section
                  const Text(
                    'Penempatan & Pembimbing',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // SMK Dropdown
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.school,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Pilih SMK Penempatan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => DropdownButtonFormField<SmkModel>(
                            value: selectedSmk.value,
                            hint: const Text('Pilih SMK'),
                            items:
                                smkList.map((smk) {
                                  return DropdownMenuItem<SmkModel>(
                                    value: smk,
                                    child: Text(smk.nama),
                                  );
                                }).toList(),
                            onChanged: (value) => selectedSmk.value = value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dosen Pembimbing Dropdown
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Pilih Dosen Pembimbing',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => DropdownButtonFormField<UserModel>(
                            value: selectedDospem.value,
                            hint: const Text('Pilih Dosen'),
                            items:
                                dospems.map((user) {
                                  return DropdownMenuItem<UserModel>(
                                    value: user,
                                    child: Text(user.name),
                                  );
                                }).toList(),
                            onChanged: (value) => selectedDospem.value = value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Guru Pamong Dropdown
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Pilih Guru Pamong',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => DropdownButtonFormField<UserModel>(
                            value: selectedGuruPamong.value,
                            hint: const Text('Pilih Guru'),
                            items:
                                guruPamongs.map((user) {
                                  return DropdownMenuItem<UserModel>(
                                    value: user,
                                    child: Text(user.name),
                                  );
                                }).toList(),
                            onChanged:
                                (value) => selectedGuruPamong.value = value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedSmk.value == null ||
                                selectedDospem.value == null ||
                                selectedGuruPamong.value == null) {
                              Get.snackbar(
                                "Validasi",
                                "Mohon pilih SMK, Dosen Pembimbing, dan Guru Pamong",
                              );
                              return;
                            }

                            onAssign(
                              registration.id!,
                              selectedSmk.value!.id!,
                              selectedDospem.value!.id!,
                              selectedGuruPamong.value!.id!,
                            );

                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Assign',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
