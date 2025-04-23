class LogbookModel {
  final int id;
  final int userId;
  final String tanggal;
  final String keterangan;
  final String mulai;
  final String selesai;
  final String dokumentasi;

  LogbookModel({
    required this.id,
    required this.userId,
    required this.tanggal,
    required this.keterangan,
    required this.mulai,
    required this.selesai,
    required this.dokumentasi,
  });

  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    return LogbookModel(
      id: json['id'],
      userId: json['user_id'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      mulai: json['mulai'],
      selesai: json['selesai'],
      dokumentasi: json['dokumentasi'],
    );
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
    };
  }
}
