import 'package:flutter/material.dart';
import 'package:plp/models/logbook_model.dart';

class LogbookDetailBottomSheet extends StatelessWidget {
  final LogbookModel logbook;
  final String userName;

  const LogbookDetailBottomSheet({
    super.key,
    required this.logbook,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(Icons.book, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Logbook',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userName.startsWith('User ID:')
                            ? 'oleh Mahasiswa'
                            : 'oleh $userName',
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
                    title: 'Mahasiswa',
                    value:
                        userName.startsWith('User ID:')
                            ? 'Mahasiswa'
                            : userName,
                    iconColor: Colors.green,
                  ),
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    title: 'Tanggal',
                    value: logbook.tanggal,
                    iconColor: Colors.orange,
                  ),
                  _buildDetailItem(
                    icon: Icons.access_time,
                    title: 'Waktu Mulai',
                    value: logbook.mulai,
                    iconColor: Colors.blue,
                  ),
                  _buildDetailItem(
                    icon: Icons.access_time_filled,
                    title: 'Waktu Selesai',
                    value: logbook.selesai,
                    iconColor: Colors.red,
                  ),
                  _buildDetailItem(
                    icon: Icons.description,
                    title: 'Keterangan',
                    value: logbook.keterangan,
                    iconColor: Colors.purple,
                    isLongText: true,
                  ),
                  if (logbook.dokumentasi.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.link,
                      title: 'Dokumentasi',
                      value: logbook.dokumentasi,
                      iconColor: Colors.teal,
                      isLink: true,
                    ),
                  _buildStatusItem(
                    icon: Icons.verified,
                    title: 'Status Guru',
                    status: logbook.status,
                    iconColor: _getStatusColor(logbook.status),
                  ),
                  _buildStatusItem(
                    icon: Icons.school,
                    title: 'Status Dosen Pembimbing',
                    status: logbook.yourApprovalStatus,
                    iconColor: _getStatusColor(logbook.yourApprovalStatus),
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
    bool isLongText = false,
    bool isLink = false,
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
                if (isLink)
                  GestureDetector(
                    onTap: () {
                      // TODO: Open link functionality
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: isLongText ? null : 2,
                    overflow: isLongText ? null : TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String status,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
