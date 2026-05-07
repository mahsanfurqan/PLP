class PendaftaranPlpModel {
  final int id;
  final int userId;
  final String namaMahasiswa;
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
    this.namaMahasiswa = '',
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
    final userMap = _asStringMap(
      _pickFirst(json, ['user', 'mahasiswa', 'student', 'mahasiswa_user']),
    );

    final namaMahasiswaRaw =
        _pickFirst(json, [
          'nama_mahasiswa',
          'namaMahasiswa',
          'student_name',
          'studentName',
          'user_name',
          'userName',
          'mahasiswa_name',
          'mahasiswaName',
          'nama',
          'name',
        ]) ??
        _pickFirstNullable(userMap, [
          'name',
          'nama',
          'full_name',
          'fullname',
          'nama_lengkap',
          'namaLengkap',
        ]);

    final namaMahasiswa = namaMahasiswaRaw?.toString().trim() ?? '';

    final penempatanRaw = _pickFirst(json, [
      'penempatan',
      'penempatan_id',
      'id_penempatan',
      'smk_penempatan',
      'smk_penempatan_id',
      'id_smk_penempatan',
      'smk_id',
      'id_smk',
      'penempatanId',
      'smkPenempatan',
      'smkPenempatanId',
    ]);

    final dosenPembimbingRaw =
        _pickFirst(json, [
          'dosen_pembimbing',
          'dosen_pembimbing_id',
          'id_dosen_pembimbing',
          'dospem_id',
          'id_dospem',
          'pembimbing_id',
          'dosen_id',
          'id_dosen',
          'dosen',
          'dosenPembimbing',
          'dosenPembimbingId',
        ]) ??
        _pickFirstNullable(userMap, [
          'dosen_pembimbing',
          'dosen_pembimbing_id',
          'id_dosen_pembimbing',
          'dospem_id',
          'id_dospem',
          'pembimbing_id',
          'dosen_id',
          'id_dosen',
          'dosen',
          'dosenPembimbing',
          'dosenPembimbingId',
        ]);

    final guruPamongRaw =
        _pickFirst(json, [
          'guru_pamong',
          'guru_pamong_id',
          'id_guru_pamong',
          'pamong_id',
          'id_pamong',
          'guru_id',
          'id_guru',
          'guru',
          'guruPamong',
          'guruPamongId',
        ]) ??
        _pickFirstNullable(userMap, [
          'guru_pamong',
          'guru_pamong_id',
          'id_guru_pamong',
          'pamong_id',
          'id_pamong',
          'guru_id',
          'id_guru',
          'guru',
          'guruPamong',
          'guruPamongId',
        ]);

    return PendaftaranPlpModel(
      id: _parseInt(_pickFirst(json, ['id', 'pendaftaran_id'])),
      userId: _parseInt(_pickFirst(json, ['user_id', 'userId', 'user'])),
      namaMahasiswa: namaMahasiswa,
      keminatanId: _parseInt(
        _pickFirst(json, ['keminatan_id', 'keminatanId', 'keminatan']),
      ),
      nilaiPlp1:
          _pickFirst(json, ['nilai_plp_1', 'nilaiPlp1'])?.toString() ?? '',
      nilaiMicroTeaching:
          _pickFirst(json, [
            'nilai_micro_teaching',
            'nilaiMicroTeaching',
          ])?.toString() ??
          '',
      pilihanSmk1: _parseInt(
        _pickFirst(json, ['pilihan_smk_1', 'pilihanSmk1', 'pilihan_smk1']),
      ),
      pilihanSmk2: _parseInt(
        _pickFirst(json, ['pilihan_smk_2', 'pilihanSmk2', 'pilihan_smk2']),
      ),
      penempatan: _parseRelationId(
        penempatanRaw,
        nestedKeys: ['id', 'smk_id', 'penempatan_id'],
      ),
      dosenPembimbing: _parseRelationId(
        dosenPembimbingRaw,
        nestedKeys: ['id', 'user_id', 'dosen_pembimbing_id'],
      ),
      guruPamong: _parseRelationId(
        guruPamongRaw,
        nestedKeys: ['id', 'user_id', 'guru_pamong_id'],
      ),
      createdAt:
          _pickFirst(json, ['created_at', 'createdAt'])?.toString() ?? '',
      updatedAt:
          _pickFirst(json, ['updated_at', 'updatedAt'])?.toString() ?? '',
    );
  }

  static dynamic _pickFirst(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key) && json[key] != null) {
        return json[key];
      }
    }
    return null;
  }

  static Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  static dynamic _pickFirstNullable(
    Map<String, dynamic>? json,
    List<String> keys,
  ) {
    if (json == null) return null;
    return _pickFirst(json, keys);
  }

  /// Helper untuk parse int dari dynamic (bisa String atau int)
  static int _parseInt(dynamic value) {
    return _parseIntNullable(value) ?? 0;
  }

  /// Helper untuk parse nullable int dari dynamic
  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);

    if (value is Map) {
      final map = value.map((key, val) => MapEntry(key.toString(), val));
      final possibleId = _pickFirst(map, [
        'id',
        'value',
        'user_id',
        'dosen_id',
        'guru_id',
        'smk_id',
        'penempatan_id',
        'dosen_pembimbing_id',
        'guru_pamong_id',
        'id_user',
        'id_dosen',
        'id_guru',
        'id_smk',
        'id_smk_penempatan',
        'id_dosen_pembimbing',
        'id_dospem',
        'id_guru_pamong',
        'id_pamong',
      ]);
      return _parseIntNullable(possibleId);
    }

    if (value is List) {
      for (final item in value) {
        final parsed = _parseIntNullable(item);
        if (parsed != null) return parsed;
      }
    }

    return null;
  }

  /// Helper untuk parse ID relasi, baik dari int langsung maupun object relasi
  static int? _parseRelationId(
    dynamic value, {
    List<String> nestedKeys = const ['id'],
  }) {
    if (value == null) return null;

    if (value is Map) {
      final map = value.map((key, val) => MapEntry(key.toString(), val));

      for (final key in nestedKeys) {
        if (map.containsKey(key) && map[key] != null) {
          final parsed = _parseIntNullable(map[key]);
          if (parsed != null) return parsed;
        }
      }

      for (final entry in map.entries) {
        if (entry.key.endsWith('_id') || entry.key.startsWith('id_')) {
          final parsed = _parseIntNullable(entry.value);
          if (parsed != null) return parsed;
        }
      }

      final deep = _extractNestedId(map);
      if (deep != null) return deep;
    }

    if (value is List) {
      final deepList = _extractNestedId(value);
      if (deepList != null) return deepList;
    }

    return _parseIntNullable(value);
  }

  static int? _extractNestedId(dynamic value, [int depth = 0]) {
    if (value == null || depth > 4) return null;

    final direct = _parseIntNullable(value);
    if (direct != null) return direct;

    if (value is Map) {
      final map = value.map((key, val) => MapEntry(key.toString(), val));

      final prioritized = _pickFirst(map, [
        'id',
        'user_id',
        'dosen_id',
        'guru_id',
        'smk_id',
        'penempatan_id',
        'dosen_pembimbing_id',
        'guru_pamong_id',
        'id_user',
        'id_dosen',
        'id_guru',
        'id_smk',
        'id_smk_penempatan',
        'id_dosen_pembimbing',
        'id_dospem',
        'id_guru_pamong',
        'id_pamong',
      ]);
      final parsedPriority = _parseIntNullable(prioritized);
      if (parsedPriority != null) return parsedPriority;

      for (final entry in map.entries) {
        final nested = _extractNestedId(entry.value, depth + 1);
        if (nested != null) return nested;
      }
    }

    if (value is List) {
      for (final item in value) {
        final nested = _extractNestedId(item, depth + 1);
        if (nested != null) return nested;
      }
    }

    return null;
  }
}
