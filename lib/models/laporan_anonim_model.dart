class LaporanAnonimModel {
  final int id;
  final String studentName;
  final String incidentDescription;
  final String incidentDate;
  final String source;
  final String? evidenceImageUrl;
  final String createdAt;
  final bool isRead;

  LaporanAnonimModel({
    required this.id,
    required this.studentName,
    required this.incidentDescription,
    required this.incidentDate,
    required this.source,
    this.evidenceImageUrl,
    required this.createdAt,
    required this.isRead,
  });

  factory LaporanAnonimModel.fromJson(Map<String, dynamic> json) {
    return LaporanAnonimModel(
      id: _safeInt(json['id']),
      studentName: _safeString(json['student_name']),
      incidentDescription: _safeString(json['incident_description']),
      incidentDate: _safeString(json['incident_date']),
      source: _safeString(json['source'], 'mobile'),
      evidenceImageUrl: _safeNullableString(json['evidence_image_url']),
      createdAt: _safeString(json['created_at']),
      isRead: _safeBool(json['is_read']),
    );
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

  static bool _safeBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  static String? _safeNullableString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }
}
