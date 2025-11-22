import 'package:flutter/material.dart';
import 'package:plp/models/pendaftaranplp_model.dart';

class RegistrationCard extends StatelessWidget {
  final PendaftaranPlpModel registration;
  final VoidCallback onTap;
  final int index;

  const RegistrationCard({
    super.key,
    required this.registration,
    required this.onTap,
    required this.index,
  });

  // Pastel colors that will cycle through
  static const List<Color> pastelColors = [
    Color(0xFFE8F5E8), // Light green
    Color(0xFFF0F8FF), // Light blue
    Color(0xFFFFF0F5), // Light pink
    Color(0xFFF0FFF0), // Light mint
    Color(0xFFFFF8DC), // Light yellow
    Color(0xFFF5F5DC), // Light beige
    Color(0xFFE6E6FA), // Light lavender
    Color(0xFFF0F8FF), // Light azure
    Color(0xFFFFFACD), // Light lemon
    Color(0xFFE0FFFF), // Light cyan
  ];

  Color get cardColor => pastelColors[index % pastelColors.length];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with registration info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_add,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pendaftaran #${registration.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'User ID: ${registration.userId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PLP',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Keminatan information
              Row(
                children: [
                  Icon(Icons.school, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Keminatan ID: ${registration.keminatanId}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Grades information
              Row(
                children: [
                  Icon(Icons.grade, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'PLP 1: ${registration.nilaiPlp1} | Micro: ${registration.nilaiMicroTeaching}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // SMK choices
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SMK 1: ${registration.pilihanSmk1} | SMK 2: ${registration.pilihanSmk2}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status indicators
              Row(
                children: [
                  Icon(Icons.assignment, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tap untuk detail',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (registration.penempatan != null ||
                            registration.dosenPembimbing != null ||
                            registration.guruPamong != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Sudah di-assign',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
