class KeminatanModel {
  final int id;
  final String nama;

  KeminatanModel({required this.id, required this.nama});

  factory KeminatanModel.fromJson(Map<String, dynamic> json) {
    return KeminatanModel(id: json['id'], nama: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': nama};
  }
}
