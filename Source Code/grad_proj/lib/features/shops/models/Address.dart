import 'dart:convert';

import 'package:grad_proj/features/shops/models/Tag.dart';

class Address {
  int? id;
  String? arabicName;
  String? englishName;
  double? lat;
  double? long;
  int? entityId;
  List<Tag>? tags;

  Address(
      {this.tags,
      this.arabicName,
      this.englishName,
      this.lat,
      this.long,
      this.entityId,
      this.id});

  factory Address.fromMap(Map<String, dynamic> data) => Address(
        tags: (data['tags'] as List<dynamic>?)
            ?.map((tag) => Tag.fromMap(tag))
            .toList(),
        arabicName: data['arabicName'] as String?,
        englishName: data['englishName'] as String?,
        lat: (data['lat'] as num?)?.toDouble(),
        long: (data['long'] as num?)?.toDouble(),
        entityId: data['entityId'] as int?,
        id: data['id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'arabicName': arabicName,
        'englishName': englishName,
        'lat': lat,
        'long': long,
        'entityId': entityId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Address].
  factory Address.fromJson(String data) {
    return Address.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Address] to a JSON string.
  String toJson() => json.encode(toMap());
}
