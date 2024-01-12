import 'dart:convert';

class Category {
  int? id;
  String? arabicName;
  String? englishName;
  bool isSelected;
  List<int>? categoryIds;
  Category(
      {this.arabicName,
      this.englishName,
      this.isSelected = false,
      this.id,
      this.categoryIds});

  factory Category.fromMap(Map<String, dynamic> data) => Category(
        id: data['id'] as int?,
        arabicName: data['arabicName'] as String?,
        englishName: data['englishName'] as String?,
        categoryIds: data['categoryIds'] as List<int>?,
      );

  Map<String, dynamic> toMap() => {
        'arabicName': arabicName,
        'englishName': englishName,
      };

  factory Category.fromJson(String data) {
    return Category.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());

  static List<Category> copyCategories(List<Category> categories) {
    return categories
        .map((category) => Category(
              id: category.id,
              arabicName: category.arabicName,
              englishName: category.englishName,
              isSelected: category.isSelected,
              categoryIds: [...?category.categoryIds], // Deep copy the list
            ))
        .toList();
  }
}
