import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/shops/models/EWeekdays.dart';
import 'package:grad_proj/features/shops/models/WorkingDay.dart';
import 'package:grad_proj/features/shops/screens/time_picker.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class ChooseTime extends StatefulWidget {
  final bool isEditMode;
  const ChooseTime({super.key, required this.isEditMode});

  @override
  State<ChooseTime> createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  double minBound = 0;
  double upperBound = 1.0;

  bool isSelected = false;

  void toggleSwitch(bool value) {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopsViewModel>(context);

    List<WorkingHours> workingHours = provider.localWorkingDays;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0.w),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          buildDragIcon(),
          Constants.gapH12,
          Text(
            AppStrings.chooseTimeTitle,
            style: TextStyleUtil.chooseScreensTextStyle,
          ),
          Constants.gapH20,
          Text(
            AppStrings.chooseTimeDescription,
            style: TextStyleUtil.addShopInputTextStyle,
          ),
          Constants.gapH14,
          Expanded(
            child: ListView.separated(
                itemCount: workingHours.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Palette.textInputBackground,
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: SizedBox(
                      height: 64.h,
                      child: ListTile(
                        dense: true,
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Text(
                            AppStrings.localizedWeekdays[
                                Weekday.values[workingHours[index].day!]]!,
                            style: TextStyleUtil.daysTxtStyle,
                          ),
                        ),
                        subtitle: Text(
                          workingHours[index].isSelected!
                              ? "${WorkingHours.formatTime(workingHours[index].openTime!)} - ${WorkingHours.formatTime(workingHours[index].closeTime!)}"
                              : AppStrings.workingTimeIsNotSelectd,
                          style: TextStyleUtil.openCLoseTimeTextStyle,
                        ),
                        trailing: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => TimePicker(
                                      dayIndex: index,
                                    ));
                          },
                          child: IgnorePointer(
                            ignoring: !workingHours[index].isSelected!,
                            child: SizedBox(
                              width: 40.w,
                              height: 40.w,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Switch.adaptive(
                                  value: workingHours[index].isSelected!,
                                  onChanged: (newValue) {
                                    provider.toggleDayIsChecked(
                                        workingHours[index]);
                                  },
                                  activeColor: Palette.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Constants.gapH12),
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
