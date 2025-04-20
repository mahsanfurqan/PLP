class PendaftaranPlpModel {
  final int id;
  final int userId;
  final int keminatanId;
  final String nilaiPlp1;
  final String nilaiMicroTeaching;
  final int pilihanSmk1;
  final int pilihanSmk2;
  final String? penempatan;
  final String? dosenPembimbing;
  final String createdAt;
  final String updatedAt;

  PendaftaranPlpModel({
    required this.id,
    required this.userId,
    required this.keminatanId,
    required this.nilaiPlp1,
    required this.nilaiMicroTeaching,
    required this.pilihanSmk1,
    required this.pilihanSmk2,
    this.penempatan,
    this.dosenPembimbing,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PendaftaranPlpModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranPlpModel(
      id: json['id'],
      userId: json['user_id'],
      keminatanId: json['keminatan_id'],
      nilaiPlp1: json['nilai_plp_1'] ?? '-', // Pastikan ada fallback jika null
      nilaiMicroTeaching: json['nilai_micro_teaching'] ?? '-',
      pilihanSmk1: json['pilihan_smk_1'],
      pilihanSmk2: json['pilihan_smk_2'],
      penempatan: json['penempatan'] ?? '-', // Fallback jika null
      dosenPembimbing: json['dosen_pembimbing'] ?? '-', // Fallback jika null
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
