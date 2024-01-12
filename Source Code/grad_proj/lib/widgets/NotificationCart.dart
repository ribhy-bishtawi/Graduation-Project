import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

import '../theme/button_styles.dart';

class NotificationCard extends StatefulWidget {
  final String title;
  final String description;
  const NotificationCard(
      {super.key, required this.title, required this.description});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: SizedBox(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.all(Constants.padding14),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    // TODO : put sizedboxes betweeen elements
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyleUtil.regularTextStyle
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      Constants.gapH12,
                      Text(widget.description,
                          style: TextStyleUtil.shopDetailsStyle),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
