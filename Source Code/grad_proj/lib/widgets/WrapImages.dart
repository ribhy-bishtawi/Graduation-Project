import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/theme/palette.dart';

class WrapImages extends StatefulWidget {
  const WrapImages(
      {super.key, required this.imagePath, required this.isEditMode});
  final String? imagePath;
  final bool isEditMode;

  @override
  State<WrapImages> createState() => _WrapImagesState();
}

class _WrapImagesState extends State<WrapImages> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopsViewModel>(context);

    return widget.imagePath != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 0, 8.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Stack(
                children: [
                  Constants.gapW4,
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child:
                          // !widget.isEditMode?
                          Image.file(
                        File(widget.imagePath!),
                        width: 110.w,
                        height: 79.h,
                        fit: BoxFit.cover,
                      )
                      // : CachedNetworkImage(
                      //     imageUrl: widget.imagePath!,
                      //     imageBuilder: (context, imageProvider) => Container(
                      //       decoration: BoxDecoration(
                      //         image: DecorationImage(
                      //             image: imageProvider,
                      //             fit: BoxFit.cover,
                      //             colorFilter: ColorFilter.mode(
                      //                 Colors.red, BlendMode.colorBurn)),
                      //       ),
                      //     ),
                      //     placeholder: (context, url) =>
                      //         CircularProgressIndicator(),
                      //     errorWidget: (context, url, error) =>
                      //         Icon(Icons.error),
                      //   ),
                      ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10.h, 10.w, 0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.whiteColor,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            provider.setImagePath(null);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Palette.textInputHintColor,
                            size: 15.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
