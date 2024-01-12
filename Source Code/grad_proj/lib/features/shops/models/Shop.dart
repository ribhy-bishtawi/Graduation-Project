import 'dart:convert';

import 'package:grad_proj/features/shops/models/Category.dart';
import 'package:grad_proj/features/shops/models/Tag.dart';
import 'package:grad_proj/features/shops/models/WorkingDay.dart';

class Shop {
  int? id;
  String arabicName;
  String englishName;
  String? facebookLink;
  String? instagramLink;
  String? tiktokLink;
  int cityId;
  String? profileImage;
  String? contactNumber;
  String? contactName;
  String type;
  String? arabicDescription;
  String? englishDescription;
  String? commercialId;
  int? ownerId;
  List<WorkingHours>? workingDays;
  List<Category>? categories;
  List<Tag>? tags;

  Shop(
      {this.id,
      required this.arabicName,
      required this.englishName,
      this.facebookLink,
      this.instagramLink,
      this.tiktokLink,
      this.cityId = 22,
      this.profileImage,
      this.contactNumber,
      this.contactName,
      required this.type,
      this.arabicDescription,
      this.englishDescription,
      this.commercialId,
      this.ownerId,
      this.workingDays,
      this.categories,
      this.tags});

  @override
  String toString() {
    return 'Shop(arabicName: $arabicName, englishName: $englishName, facebookLink: $facebookLink, instgramLink: $instagramLink, tiktokLink: $tiktokLink, cityId: $cityId, profileImage: $profileImage, contactNumber: $contactNumber, contactName: $contactName, type: $type, arabicDescription: $arabicDescription, englishDescription: $englishDescription, commercialId: $commercialId, ownerId: $ownerId)';
  }

  factory Shop.fromMap(Map<String, dynamic> data) => Shop(
        id: data['id'] as int?,
        arabicName: data['arabicName'] as String,
        englishName: data['englishName'] as String,
        facebookLink: data['facebookLink'] as String?,
        instagramLink: data['instgramLink'] as String?,
        tiktokLink: data['tiktokLink'] as String?,
        cityId: data['cityId'] as int,
        profileImage: data['profileImage'] as String?,
        contactNumber: data['contactNumber'] as String?,
        contactName: data['contactName'] as String?,
        type: data['type'] as String,
        arabicDescription: data['arabicDescription'] as String?,
        englishDescription: data['englishDescription'] as String?,
        commercialId: data['commercialId'] as String?,
        ownerId: data['ownerId'] as int?,
        categories: (data['categories'] as List<dynamic>?)
            ?.map((category) => Category.fromMap(category))
            .toList(),
        workingDays: (data['workingDays'] as List<dynamic>?)
            ?.map((day) => WorkingHours.fromMap(day))
            .toList(),
        tags: (data['tags'] as List<dynamic>?)
            ?.map((tag) => Tag.fromMap(tag))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'arabicName': arabicName,
        'englishName': englishName,
        'facebookLink': facebookLink,
        'instgramLink': instagramLink,
        'tiktokLink': tiktokLink,
        'cityId': cityId,
        'profileImage': profileImage,
        'contactNumber': contactNumber,
        'contactName': contactName,
        'type': type,
        'arabicDescription': arabicDescription,
        'englishDescription': englishDescription,
        'commercialId': commercialId,
        'ownerId': ownerId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shop].
  factory Shop.fromJson(String data) {
    return Shop.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Shop] to a JSON string.
  String toJson() => json.encode(toMap());

  Shop copyWith({
    String? arabicName,
    String? englishName,
    String? facebookLink,
    String? instgramLink,
    String? tiktokLink,
    int? cityId,
    String? profileImage,
    String? contactNumber,
    String? contactName,
    String? type,
    String? arabicDescription,
    String? englishDescription,
    String? commercialId,
    int? ownerId,
  }) {
    return Shop(
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      facebookLink: facebookLink ?? this.facebookLink,
      instagramLink: instgramLink ?? this.instagramLink,
      tiktokLink: tiktokLink ?? this.tiktokLink,
      cityId: cityId ?? this.cityId,
      profileImage: profileImage ?? this.profileImage,
      contactNumber: contactNumber ?? this.contactNumber,
      contactName: contactName ?? this.contactName,
      type: type ?? this.type,
      arabicDescription: arabicDescription ?? this.arabicDescription,
      englishDescription: englishDescription ?? this.englishDescription,
      commercialId: commercialId ?? this.commercialId,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
