import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/shops/models/WorkingDay.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class TimePicker extends StatefulWidget {
  final int dayIndex;

  const TimePicker({super.key, required this.dayIndex});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int selectedHour = 1;
  int selectedMinute = 0;
  DateTime openTime = DateTime.now();
  DateTime closeTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    openTime = getDateTime();
    closeTime = getDateTime();
  }

  @override
  Widget build(BuildContext context) {
    final dayIndex = widget.dayIndex;
    final provider = Provider.of<ShopsViewModel>(context);
    List<WorkingHours> workingHours = provider.localWorkingDays;
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shadows: [
          BoxShadow(
              blurRadius: 5.0.w,
              spreadRadius: 2.0.w,
              color: const Color(0x11000000))
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
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
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  closeTimeBuildTimePicker(),
                  openTimeBuildTimePicker(),
                ],
              );
            },
          ),
          Constants.gapH20,
          ElevatedButton(
              onPressed: () {
                provider.toggleDayIsChecked(workingHours[dayIndex]);
                workingHours[dayIndex].openTime =
                    (openTime.hour * 60 + openTime.minute) / 60;
                workingHours[dayIndex].closeTime =
                    (closeTime.hour * 60 + closeTime.minute) / 60;
                Routemaster.of(context).pop();
              },
              style: ButtonStyles.primaryButtonStyle,
              child: Text(
                AppStrings.shopInformationSaveButton,
                style: TextStyleUtil.buttonTextStyle,
              )),
        ],
      ),
    );
  }

  Widget openTimeBuildTimePicker() => SizedBox(
        width: 100.w,
        height: 102.h,
        child: CupertinoDatePicker(
          initialDateTime: closeTime,
          mode: CupertinoDatePickerMode.time,
          minuteInterval: 30,
          use24hFormat: true,
          itemExtent: 38.h,
          onDateTimeChanged: (dateTime) => setState(() => openTime = dateTime),
        ),
      );
  Widget closeTimeBuildTimePicker() => SizedBox(
        width: 100.w,
        height: 102.h,
        child: CupertinoDatePicker(
          initialDateTime: closeTime,
          mode: CupertinoDatePickerMode.time,
          minuteInterval: 30,
          use24hFormat: true,
          itemExtent: 38.h,
          onDateTimeChanged: (dateTime) => setState(() => closeTime = dateTime),
        ),
      );

  DateTime getDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, 30);
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
