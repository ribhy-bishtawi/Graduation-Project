import 'dart:convert';

class Offer {
  int? id;
  String? arabicTitle;
  String? englishTitle;
  String? arabicDescription;
  String? englishDescription;
  String? imageName;
  String? startDate;
  String? endDate;

  Offer({
    this.id,
    this.arabicTitle,
    this.englishTitle,
    this.arabicDescription,
    this.englishDescription,
    this.imageName,
    this.startDate,
    this.endDate,
  });

  factory Offer.fromMap(Map<String, dynamic> data) => Offer(
        id: data['id'] as int?,
        arabicTitle: data['arabicTitle'] as String?,
        englishTitle: data['englishTitle'] as String?,
        arabicDescription: data['arabicDescription'] as String?,
        englishDescription: data['englishDescription'] as String?,
        imageName: data['imageName'] as String?,
        startDate: data['startDate'] as String?,
        endDate: data['endDate'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'arabicTitle': arabicTitle,
        'englishTitle': englishTitle,
        'arabicDescription': arabicDescription,
        'englishDescription': englishDescription,
        'imageName': imageName,
        'startDate': startDate,
        'endDate': endDate,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Offer].
  factory Offer.fromJson(String data) {
    return Offer.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Offer] to a JSON string.
  String toJson() => json.encode(toMap());
}
