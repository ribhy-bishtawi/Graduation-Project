import 'package:grad_proj/resources/app_strings.dart';

class Validators {
  static String? validateShopNameInArabic(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredFieldErrorMessage;
    }

    final arabicRegex = RegExp(r'^[^\p{IsBasicLatin}a-zA-Z]+$');

    if (!arabicRegex.hasMatch(value)) {
      return AppStrings.arabicTextOnlyErrorMeesage;
    }
    return null;
  }

  static String? validateShopNameInEnglish(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredFieldErrorMessage;
    }
    final englishRegex = RegExp(r'^[a-zA-Z0-9\s]+$');

    if (!englishRegex.hasMatch(value)) {
      return AppStrings.englishTextOnlyErrorMeesage;
    }
    return null;
  }

  static String? validateFacebookLink(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final facebookRegex = RegExp(r'^https?://(www\.)?facebook\.com/\S+');

    if (!facebookRegex.hasMatch(value)) {
      return AppStrings.validFacebookLinkErrorMeesage;
    }

    return null;
  }

  static String? validateTikTokAccount(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final tiktokRegex = RegExp(r'^https?://(www\.)?tiktok\.com/\S+');

    if (!tiktokRegex.hasMatch(value)) {
      return AppStrings.validInstagramLinkErrorMeesage;
    }

    return null;
  }

  static String? validateInstagramLink(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final instagramRegex = RegExp(r'^https?://(www\.)?instagram\.com/\S+');

    if (!instagramRegex.hasMatch(value)) {
      return 'Please enter a valid Instagram link';
    }

    return null;
  }

  static String? validateCategory(bool isChecked) {
    if (!isChecked) {
      return 'This field is required';
    }
    return null;
  }
}
