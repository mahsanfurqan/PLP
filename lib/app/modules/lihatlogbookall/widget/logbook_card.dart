import 'package:flutter/material.dart';
import 'package:plp/models/logbook_model.dart';

class LogbookCard extends StatelessWidget {
  final LogbookModel logbook;
  final String userName;
  final VoidCallback onTap;
  final int index;

  const LogbookCard({
    super.key,
    required this.logbook,
    required this.userName,
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
              // Header with user info and date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
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
                          userName.startsWith('User ID:')
                              ? 'Mahasiswa'
                              : userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          logbook.tanggal,
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
                      color: _getStatusColor(logbook.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      logbook.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(logbook.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Time information
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${logbook.mulai} - ${logbook.selesai}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                logbook.keterangan.length > 50
                    ? '${logbook.keterangan.substring(0, 50)}...'
                    : logbook.keterangan,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Documentation link
              if (logbook.dokumentasi.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.link, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dokumentasi tersedia',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
