import 'dart:convert';

class WorkingHours {
  int? id;
  int? entityId;
  int? day;
  double? openTime;
  double? closeTime;
  bool? isSelected;
  WorkingHours(
      {this.id,
      this.entityId,
      this.day,
      this.openTime,
      this.closeTime,
      this.isSelected});

  factory WorkingHours.fromMap(Map<String, dynamic> data) => WorkingHours(
      id: data['id'] as int?,
      entityId: data['entityId'] as int?,
      day: data['day'] as int?,
      openTime: data['openTime'] as double?,
      closeTime: data['closeTime'] as double?,
      isSelected: true);

  Map<String, dynamic> toMap() => {
        'entityId': entityId,
        'day': day,
        'openTime': openTime,
        'closeTime': closeTime,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WorkingHours].
  factory WorkingHours.fromJson(String data) {
    return WorkingHours.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WorkingHours] to a JSON string.
  String toJson() => json.encode(toMap());

  static String formatTime(double timeValue) {
    int hours = timeValue.toInt();
    int minutes = ((timeValue - hours) * 60).toInt();
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  static List<WorkingHours> copyWorkingDays(List<WorkingHours> workingDays) {
    return workingDays
        .map((day) => WorkingHours(
              entityId: day.entityId,
              day: day.day,
              openTime: day.openTime,
              closeTime: day.closeTime,
              isSelected: day.isSelected, // Deep copy the list
            ))
        .toList();
  }
}
