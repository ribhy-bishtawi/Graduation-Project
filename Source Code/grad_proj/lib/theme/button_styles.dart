import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/theme/palette.dart';

class ButtonStyles {
  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      minimumSize: Size.fromHeight(48.h),
      disabledBackgroundColor: Palette.secondaryButtonBackground,
      backgroundColor: Palette.secondaryButtonBackground,
      elevation: 0);
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      minimumSize: Size.fromHeight(48.h),
      disabledBackgroundColor: Palette.primaryButtonDisabledBackground,
      backgroundColor: Palette.primary,
      elevation: 0);
  static final ButtonStyle addShopBranchButtonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      minimumSize: Size.fromHeight(48.h),
      backgroundColor: const Color(0xFFFFFDFA),
      elevation: 0,
      side: BorderSide(
        width: 2.w, // the thickness
        color: const Color(0x88804D00),
      ) // the color of the border
      );
  static final ButtonStyle addShopInformationButtonStyle =
      ElevatedButton.styleFrom(
    shape: const StadiumBorder(),
    minimumSize: Size.fromHeight(48.h),
    backgroundColor: Palette.textInputBackground,
    elevation: 0,
  );
  static final ButtonStyle floatingActionButtonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      disabledBackgroundColor: Palette.primaryButtonDisabledBackground,
      backgroundColor: Palette.primary,
      elevation: 0);
  static final ButtonStyle circularButtonStyle = ElevatedButton.styleFrom(
      shape: const CircleBorder(), // fixedSize: Size(28, 28),
      padding: EdgeInsets.all(8.h),
      backgroundColor: Palette.whiteColor);
  static final ButtonStyle cancelButtonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      elevation: 0,
      side: const BorderSide(color: Palette.genderUnselectedBorder),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      backgroundColor: Palette.whiteColor);
  static final ButtonStyle deleteButtonStyle = ElevatedButton.styleFrom(
    shape: const StadiumBorder(),
    elevation: 0,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    backgroundColor: Palette.warning,
  );
}
