import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class DeleteShop extends StatefulWidget {
  final VoidCallback onCancelClicked;
  final VoidCallback onConfirmDeleteClicked;
  final int shopId;
  const DeleteShop(
      {super.key,
      required this.onCancelClicked,
      required this.onConfirmDeleteClicked,
      required this.shopId});

  @override
  State<DeleteShop> createState() => _DeleteShopState();
}

class _DeleteShopState extends State<DeleteShop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shadows: [
          BoxShadow(
              blurRadius: 5.0.w,
              spreadRadius: 2.0.w,
              color: const Color(0x11000000))
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0.w),
            topRight: Radius.circular(12.0.w),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 20.w),
      child: Column(
        children: <Widget>[
          buildDragIcon(),
          Constants.gapH36,
          Text(
            AppStrings.deleteShop,
            style: TextStyleUtil.modalBottomSheetTitleTextStyle,
          ),
          Constants.gapH24,
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirmDeleteClicked();
                  },
                  style: ButtonStyles.deleteButtonStyle,
                  child: Text(
                    AppStrings.confirmDelete,
                    style: TextStyleUtil.buttonTextStyle,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onCancelClicked();
                  },
                  style: ButtonStyles.cancelButtonStyle,
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyleUtil.cancelButtonStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDragIcon() => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(6.w),
        ),
        width: 38.w,
        height: 4.h,
      );
}
