class LogbookModel {
  final int id;
  final int userId;
  final String tanggal;
  final String keterangan;
  final String mulai;
  final String selesai;
  final String dokumentasi;
  final String status; // status logbook mahasiswa
  final String yourApprovalStatus; // status validasi dari akun guru/dosen

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
      id: json['id'],
      userId: json['user_id'] ?? 0, // kalau tidak ada, default 0
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      mulai: json['mulai'],
      selesai: json['selesai'],
      dokumentasi: json['dokumentasi'],
      status: json['status'] ?? 'pending',
      yourApprovalStatus: json['your_approval_status'] ?? 'pending',
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
      'status': status,
      'your_approval_status': yourApprovalStatus,
    };
  }
}
