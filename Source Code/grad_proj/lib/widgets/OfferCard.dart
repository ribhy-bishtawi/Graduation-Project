import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/Offers/models/offer.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

import '../theme/button_styles.dart';

class OfferCard extends StatefulWidget {
  final Offer offer;
  final VoidCallback onShopDeletePressed;
  const OfferCard(
      {super.key, required this.offer, required this.onShopDeletePressed});

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  String parseData(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    Offer offer = widget.offer;
    String offerStartDate = parseData(offer.startDate!);
    String offerEndDate = parseData(offer.endDate!);

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
                    "assets/images/offer_image.png",
                    fit: BoxFit.fill,
                    height: 140.h,
                    // width: 350.w,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                  alignment: Alignment.centerLeft,
                  child: Column(
                    // TODO : put sizedboxes betweeen elements
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //   image
                      Text(
                        offer.englishTitle!,
                        style: TextStyleUtil.regularTextStyle
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      Constants.gapH12,
                      Text(offer.englishDescription!,
                          style: TextStyleUtil.shopDetailsStyle),
                      Constants.gapH12,

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[
                              200], // Replace with your desired background color
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "${offerStartDate}  ",
                                style: TextStyleUtil.shopDetailsStyle,
                              ),
                              TextSpan(
                                text: AppStrings
                                    .bettwenStartAndEndDateInTheOfferCard,
                                style: TextStyleUtil.shopDetailsStyle,
                              ),
                              TextSpan(
                                text: offerEndDate,
                                style: TextStyleUtil.shopDetailsStyle,
                              ),
                            ],
                          ),
                        ),
                      )
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.phone,
                      //       color: Palette.secondaryTextColor,
                      //       size: Constants.iconSize,
                      //     ),
                      //     Text(widget.phoneNumber,
                      //         style: TextStyleUtil.shopDetailsStyle),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.location_pin,
                      //       color: Palette.secondaryTextColor,
                      //       size: Constants.iconSize,
                      //     ),
                      //     Text(widget.address,
                      //         style: TextStyleUtil.shopDetailsStyle),
                      //   ],
                      // )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
