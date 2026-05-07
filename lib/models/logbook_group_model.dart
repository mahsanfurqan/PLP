import 'package:plp/models/logbook_model.dart';

class LogbookGroupStudentModel {
  final int id;
  final String name;

  const LogbookGroupStudentModel({
    required this.id,
    required this.name,
  });

  factory LogbookGroupStudentModel.fromJson(Map<String, dynamic> json) {
    return LogbookGroupStudentModel(
      id: _safeInt(json['id']),
      name: _safeString(json['name'], 'Mahasiswa'),
    );
  }
}

class LogbookGroupSupervisorModel {
  final int id;
  final String name;

  const LogbookGroupSupervisorModel({
    required this.id,
    required this.name,
  });

  factory LogbookGroupSupervisorModel.fromJson(Map<String, dynamic> json) {
    return LogbookGroupSupervisorModel(
      id: _safeInt(json['id']),
      name: _safeString(json['name'], '-'),
    );
  }
}

class LogbookGroupModel {
  final int id;
  final String name;
  final LogbookGroupSupervisorModel dosenPembimbing;
  final LogbookGroupSupervisorModel guruPamong;
  final int studentCount;
  final int logbookCount;
  final List<LogbookGroupStudentModel> students;
  final List<LogbookModel> logbooks;

  const LogbookGroupModel({
    required this.id,
    required this.name,
    required this.dosenPembimbing,
    required this.guruPamong,
    required this.studentCount,
    required this.logbookCount,
    required this.students,
    required this.logbooks,
  });

  factory LogbookGroupModel.fromJson(Map<String, dynamic> json) {
    final studentItems =
        (json['students'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(LogbookGroupStudentModel.fromJson)
            .toList();

    final logbookItems =
        (json['logbooks'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(LogbookModel.fromJson)
            .toList();

    return LogbookGroupModel(
      id: _safeInt(json['id']),
      name: _safeString(json['name'], 'Kelompok'),
      dosenPembimbing: LogbookGroupSupervisorModel.fromJson(
        (json['dosen_pembimbing'] as Map<String, dynamic>?) ?? const {},
      ),
      guruPamong: LogbookGroupSupervisorModel.fromJson(
        (json['guru_pamong'] as Map<String, dynamic>?) ?? const {},
      ),
      studentCount: _safeInt(json['student_count']),
      logbookCount: _safeInt(json['logbook_count']),
      students: studentItems,
      logbooks: logbookItems,
    );
  }
}

int _safeInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _safeString(dynamic value, [String defaultValue = '']) {
  if (value is String) return value;
  if (value == null) return defaultValue;
  return value.toString();
}
