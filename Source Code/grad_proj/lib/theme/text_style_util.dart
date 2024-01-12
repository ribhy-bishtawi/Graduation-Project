import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/theme/palette.dart';

class TextStyleUtil {
  static TextStyle buttonTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Palette.whiteColor,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle regularTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Palette.textInputText,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );

  static TextStyle secondaryButtonTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Palette.primary,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle shopDetailsStyle = TextStyle(
    fontSize: 12.sp,
    color: Palette.shopDetailsText,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle titleTextStyle = TextStyle(
    color: Palette.textInputHintColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    fontFamily: "Almarai",
  );

  static TextStyle subtitleTextStyle = TextStyle(
    color: Palette.textInputHintColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle settingsTitleTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Palette.settingsTitleText,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );

  static TextStyle hintTextStyle = TextStyle(
    color: Palette.secondaryTextColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle linkStyle =
      regularTextStyle.copyWith(color: Palette.primary, fontSize: 14.sp);

  static TextStyle selectedLabelStyle =
      TextStyle(fontFamily: "Almarai", fontSize: 14.sp);
  static TextStyle unselectedLabelStyle =
      TextStyle(fontFamily: "Almarai", fontSize: 14.sp);

  static TextStyle cancelButtonStyle = TextStyle(
      fontFamily: "Almarai",
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: Palette.cancelText);
  static InputBorder errorTextFieldStyle(bool smallCircularBorder) {
    double radius = 0;
    if (smallCircularBorder) {
      radius = 20;
    } else {
      radius = 300;
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Palette.textInputError),
    );
  }

  static InputBorder enabledTextFieldBorder(
      bool isTextEmpty, bool smallCircularBorder) {
    double radius = 0;
    if (smallCircularBorder) {
      radius = 20;
    } else {
      radius = 300;
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
          color: isTextEmpty
              ? Palette.textInputFocusedBorder
              : Colors.transparent),
    );
  }

  static InputBorder focusedBorder(bool smallCircularBorder) {
    double radius = 0;
    if (smallCircularBorder) {
      radius = 20;
    } else {
      radius = 300;
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Palette.textInputFocusedBorder),
    );
  }

  static TextStyle addShopInputTextStyle = TextStyle(
    fontSize: 14.sp,
    color: Palette.addShopTextInput,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle chooseImageTextStyle = TextStyle(
    fontSize: 14.sp,
    color: Palette.primary,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );

  static TextStyle addShopHeaderTextStyle = TextStyle(
    fontSize: 16.sp,
    // TODO change the name of the color
    color: Palette.textInputText,
    fontWeight: FontWeight.w700,
    fontFamily: "Almarai",
  );
  static TextStyle addShopBranchTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Palette.primary,
    fontWeight: FontWeight.w700,
    fontFamily: "Almarai",
  );

  static TextStyle chooseScreensTextStyle = TextStyle(
    fontSize: 18.sp,
    color: Palette.black,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle modalBottomSheetTitleTextStyle = const TextStyle(
    fontSize: 20,
    color: Palette.designBlack,
    fontWeight: FontWeight.w700,
    fontFamily: "Almarai",
  );
  static TextStyle timeSpinnerTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Palette.black,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle tagWordsTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Palette.black,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle errorTextStyle = TextStyle(
    color: Palette.textInputError,
    fontSize: 10.0.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle openCLoseTimeTextStyle = TextStyle(
    color: Palette.black,
    fontSize: 16.0.sp,
    fontWeight: FontWeight.w700,
    fontFamily: "Almarai",
  );
  static TextStyle daysTxtStyle = TextStyle(
    fontSize: 14.sp,
    color: Palette.daysColor,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle notificationScreenText = const TextStyle(
    fontSize: 20,
    color: Palette.black,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
  static TextStyle addNotificationScreenText = const TextStyle(
    fontSize: 14,
    color: Palette.black,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );
}
