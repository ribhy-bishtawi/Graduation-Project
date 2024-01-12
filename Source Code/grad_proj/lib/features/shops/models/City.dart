import 'dart:convert';

class City {
  int? id;
  String? arabicName;
  String? englishName;
  bool isSelected;

  City({this.id, this.arabicName, this.englishName, this.isSelected = false});

  factory City.fromMap(Map<String, dynamic> data) => City(
        id: data['id'] as int?,
        arabicName: data['arabicName'] as String?,
        englishName: data['englishName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'arabicName': arabicName,
        'englishName': englishName,
      };

  factory City.fromJson(String data) {
    return City.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());
}
