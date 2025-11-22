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

  LogbookModel({
    required this.id,
    required this.userId,
    required this.tanggal,
    required this.keterangan,
    required this.mulai,
    required this.selesai,
    required this.dokumentasi,
    required this.status,
    required this.yourApprovalStatus,
  });

  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    return LogbookModel(
      id: _safeInt(json['id']),
      userId: _safeInt(json['user_id'] ?? json['userId']),
      tanggal: _safeString(json['tanggal']),
      keterangan: _safeString(json['keterangan']),
      mulai: _convertToString(json['mulai']),
      selesai: _convertToString(json['selesai']),
      dokumentasi: _safeString(json['dokumentasi']),
      status: _safeString(json['status'], 'pending'),
      yourApprovalStatus: _safeString(json['your_approval_status'], 'pending'),
    );
  }

  static int _safeInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value == null) return 0;
    return 0;
  }

  static String _safeString(dynamic value, [String defaultValue = '']) {
    if (value is String) return value;
    if (value == null) return defaultValue;
    return value.toString();
  }

  static String _convertToString(dynamic value) {
    if (value is String) {
      if (value.isEmpty) return '00:00';
      if (value.contains(':') && value.split(':').length == 3) {
        List<String> parts = value.split(':');
        return '${parts[0]}:${parts[1]}';
      }
      return value;
    }
    if (value is int) {
      if (value == 0) return '00:00';
      String str = value.toString().padLeft(4, '0');
      return '${str.substring(0, 2)}:${str.substring(2, 4)}';
    }
    if (value == null) return '00:00';
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'mulai': mulai,
      'selesai': selesai,
      'dokumentasi': dokumentasi,
      'status': status,
      'your_approval_status': yourApprovalStatus,
    };
  }
}
