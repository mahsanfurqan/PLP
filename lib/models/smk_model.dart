class SmkModel {
  final int id;
  final String nama;

  SmkModel({required this.id, required this.nama});

  factory SmkModel.fromJson(Map<String, dynamic> json) {
    return SmkModel(id: json['id'], nama: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': nama};
  }
}
