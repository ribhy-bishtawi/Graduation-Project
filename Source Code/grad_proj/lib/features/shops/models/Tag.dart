import 'dart:convert';

class Tag {
  int? id;
  String arabicName;
  String? englishName;

  Tag({required this.arabicName, this.englishName, this.id});

  factory Tag.fromMap(Map<String, dynamic> data) => Tag(
        id: data['id'] as int?,
        arabicName: data['arabicName'] as String,
        englishName: data['englishName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'arabicName': arabicName,
        'englishName': englishName,
      };

  factory Tag.fromJson(String data) {
    return Tag.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());
}
