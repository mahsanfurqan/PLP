class LogbookApprovalModel {
  final int id;
  final int approverId;
  final String name;
  final String role;
  final String status;
  final String note;
  final String updatedAt;

  const LogbookApprovalModel({
    required this.id,
    required this.approverId,
    required this.name,
    required this.role,
    required this.status,
    required this.note,
    required this.updatedAt,
  });

  factory LogbookApprovalModel.fromJson(Map<String, dynamic> json) {
    return LogbookApprovalModel(
      id: LogbookModel._safeInt(json['id']),
      approverId: LogbookModel._safeInt(
        json['approver_id'] ?? json['approverId'],
      ),
      name: LogbookModel._safeString(json['name'], 'Approver'),
      role: LogbookModel._safeString(json['role']),
      status: LogbookModel._safeString(json['status'], 'pending'),
      note: LogbookModel._safeString(json['note']),
      updatedAt: LogbookModel._safeString(
        json['updated_at'] ?? json['updatedAt'],
      ),
    );
  }
}

class LogbookModel {
  final int id;
  final int userId;
  final String tanggal;
  final String keterangan;
  final String mulai;
  final String selesai;
  final String dokumentasi;
  final String status;
  final String yourApprovalStatus;
  final String yourNote;
  final String? userName;
  final bool canEdit;
  final List<LogbookApprovalModel> approvers;

  const LogbookModel({
    required this.id,
    required this.userId,
    required this.tanggal,
    required this.keterangan,
    required this.mulai,
    required this.selesai,
    required this.dokumentasi,
    required this.status,
    required this.yourApprovalStatus,
    required this.yourNote,
    required this.canEdit,
    required this.approvers,
    this.userName,
  });

  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    String? extractedUserName;

    if (json['user'] is String) {
      extractedUserName = json['user'] as String;
    } else if (json['user'] is Map<String, dynamic>) {
      extractedUserName = json['user']['name'] as String?;
    }

    extractedUserName ??=
        json['user_name'] as String? ??
        json['userName'] as String? ??
        json['nama_mahasiswa'] as String?;

    final approverList =
        (json['approvers'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(LogbookApprovalModel.fromJson)
            .toList();

    return LogbookModel(
      id: _safeInt(json['id']),
      userId: _safeInt(json['user_id'] ?? json['userId']),
      tanggal: _safeString(json['tanggal']),
      keterangan: _safeString(json['keterangan']),
      mulai: _convertTime(json['mulai']),
      selesai: _convertTime(json['selesai']),
      dokumentasi: _safeString(json['dokumentasi']),
      status: _safeString(json['status'], 'pending'),
      yourApprovalStatus: _safeString(json['your_approval_status'], 'pending'),
      yourNote: _safeString(json['your_note']),
      userName: extractedUserName,
      canEdit:
          json['can_edit'] == true ||
          approverList.any((approval) => approval.status == 'rejected'),
      approvers: approverList,
    );
  }

  LogbookApprovalModel? get rejectedApproval {
    for (final approval in approvers) {
      if (approval.status.toLowerCase() == 'rejected') {
        return approval;
      }
    }
    return null;
  }

  static int _safeInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _safeString(dynamic value, [String defaultValue = '']) {
    if (value is String) return value;
    if (value == null) return defaultValue;
    return value.toString();
  }

  static String _convertTime(dynamic value) {
    if (value is String) {
      if (value.isEmpty) return '00:00';
      final parts = value.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
      return value;
    }

    if (value == null) return '00:00';
    return value.toString();
  }
}
