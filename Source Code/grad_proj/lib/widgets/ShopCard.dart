import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

import '../theme/button_styles.dart';

class ShopCard extends StatefulWidget {
  final String shopName;
  final String city;
  final String description;
  final String phoneNumber;
  final String address;
  final VoidCallback onEditPressed;
  final VoidCallback onShopDeletePressed;

  const ShopCard(
      {super.key,
      required this.shopName,
      required this.city,
      required this.description,
      required this.phoneNumber,
      required this.address,
      required this.onEditPressed,
      required this.onShopDeletePressed});

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
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
            Stack(
              children: [
                SizedBox(
                  // todo: change this with a proper placeholder image
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/shop_placeholder.png",
                    fit: BoxFit.fill,
                    height: 140.h,
                    // width: 350.w,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: widget.onEditPressed,
                        style: ButtonStyles.circularButtonStyle,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        )),
                    ElevatedButton(
                      onPressed: widget.onShopDeletePressed,
                      style: ButtonStyles.circularButtonStyle,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(Constants.padding14),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    // TODO : put sizedboxes betweeen elements
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //   image
                      Text(
                        widget.shopName,
                        style: TextStyleUtil.regularTextStyle
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      Constants.gapH12,
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text:
                                // widget.city
                                "${widget.city} • ",
                            style: TextStyleUtil.shopDetailsStyle
                                .copyWith(color: Colors.black)),
                        TextSpan(
                            text: widget.description,
                            style: TextStyleUtil.shopDetailsStyle)
                      ])),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Palette.secondaryTextColor,
                            size: Constants.iconSize,
                          ),
                          Text(widget.phoneNumber,
                              style: TextStyleUtil.shopDetailsStyle),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Palette.secondaryTextColor,
                            size: Constants.iconSize,
                          ),
                          Text(widget.address,
                              style: TextStyleUtil.shopDetailsStyle),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
