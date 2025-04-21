class LogbookModel {
  final int id;
  final int mahasiswaId;
  final String tanggal;
  final String uraian;
  final String durasi;
  final String dokumentasi;
  final String linkPendukung;

  LogbookModel({
    required this.id,
    required this.mahasiswaId,
    required this.tanggal,
    required this.uraian,
    required this.durasi,
    required this.dokumentasi,
    required this.linkPendukung,
  });

  // Create LogbookModel from JSON
  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    return LogbookModel(
      id: json['id'],
      mahasiswaId: json['mahasiswa_id'],
      tanggal: json['tanggal'],
      uraian: json['uraian'],
      durasi: json['durasi'],
      dokumentasi: json['dokumentasi'],
      linkPendukung: json['link_pendukung'],
    );
  }

  // Convert LogbookModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mahasiswa_id': mahasiswaId,
      'tanggal': tanggal,
      'uraian': uraian,
      'durasi': durasi,
      'dokumentasi': dokumentasi,
      'link_pendukung': linkPendukung,
    };
  }
}
