class PendaftaranPlpModel {
  final int id;
  final int userId;
  final int keminatanId;
  final String nilaiPlp1;
  final String nilaiMicroTeaching;
  final int pilihanSmk1;
  final int pilihanSmk2;
  final int? penempatan;
  final int? dosenPembimbing;
  final int? guruPamong; // ✅ Tambahan field guru_pamong
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
    this.guruPamong, // ✅ Tambahkan di constructor
    required this.createdAt,
    required this.updatedAt,
  });

  factory PendaftaranPlpModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranPlpModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      keminatanId: _parseInt(json['keminatan_id']),
      nilaiPlp1: json['nilai_plp_1']?.toString() ?? '',
      nilaiMicroTeaching: json['nilai_micro_teaching']?.toString() ?? '',
      pilihanSmk1: _parseInt(json['pilihan_smk_1']),
      pilihanSmk2: _parseInt(json['pilihan_smk_2']),
      penempatan: _parseIntNullable(json['penempatan']),
      dosenPembimbing: _parseIntNullable(json['dosen_pembimbing']),
      guruPamong: _parseIntNullable(json['guru_pamong']),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  /// Helper untuk parse int dari dynamic (bisa String atau int)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Helper untuk parse nullable int dari dynamic
  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
