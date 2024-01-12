import 'dart:convert';

class Notification {
  String? arabicTitle;
  String? englishTitle;
  String? arabicDescription;
  String? englishDescription;
  int? senderId;

  Notification({
    this.arabicTitle,
    this.englishTitle,
    this.arabicDescription,
    this.englishDescription,
    this.senderId,
  });

  factory Notification.fromMap(Map<String, dynamic> data) => Notification(
        arabicTitle: data['arabicTitle'] as String?,
        englishTitle: data['englishTitle'] as String?,
        arabicDescription: data['arabicDescription'] as String?,
        englishDescription: data['englishDescription'] as String?,
        senderId: data['senderId'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'arabicTitle': arabicTitle,
        'englishTitle': englishTitle,
        'arabicDescription': arabicDescription,
        'englishDescription': englishDescription,
        'senderId': senderId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Notification].
  factory Notification.fromJson(String data) {
    return Notification.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Notification] to a JSON string.
  String toJson() => json.encode(toMap());
}
