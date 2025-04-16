class PendaftaranPlpModel {
  final int userId;
  final int keminatanId;
  final String nilaiPlp1;
  final String nilaiMicroTeaching;
  final int pilihanSmk1;
  final int pilihanSmk2;
  final String createdAt;
  final String updatedAt;
  final int id;

  PendaftaranPlpModel({
    required this.userId,
    required this.keminatanId,
    required this.nilaiPlp1,
    required this.nilaiMicroTeaching,
    required this.pilihanSmk1,
    required this.pilihanSmk2,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory PendaftaranPlpModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranPlpModel(
      userId: json['user_id'],
      keminatanId: json['keminatan_id'],
      nilaiPlp1: json['nilai_plp_1'],
      nilaiMicroTeaching: json['nilai_micro_teaching'],
      pilihanSmk1: json['pilihan_smk_1'],
      pilihanSmk2: json['pilihan_smk_2'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      id: json['id'],
    );
  }
}
