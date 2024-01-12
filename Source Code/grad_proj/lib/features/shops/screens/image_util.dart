import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/core/helper/permission_manager.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class ImageUtils {
  static Future<String?> selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return null;
    }
  }

  static Future<String?> selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return null;
    }
  }

  static Future<dynamic> selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          String? selectedImagePath;
          final provider = Provider.of<ShopsViewModel>(context, listen: false);

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0.w)),
            child: SizedBox(
              height: 150.h,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(AppStrings.choosePhotoPageTitle,
                        style: TextStyleUtil.chooseScreensTextStyle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await PermissionManager.requestStorage();
                            selectedImagePath = await selectImageFromGallery();
                            if (selectedImagePath != null) {
                              provider.uploadImage(selectedImagePath!);
                              provider.setImagePath(selectedImagePath!);
                              Routemaster.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("No Image Selected !"),
                              ));
                            }
                          },
                          child: Card(
                              color: Palette.textInputBackground,
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/Gallery.png',
                                      height: 60.w,
                                      width: 60.w,
                                    ),
                                    Text(
                                      AppStrings.choosePhtoFromGallery,
                                      style: TextStyleUtil.chooseImageTextStyle,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await PermissionManager.requestCamera();
                            selectedImagePath = await selectImageFromCamera();
                            if (selectedImagePath != null) {
                              provider.uploadImage(selectedImagePath!);
                              provider.setImagePath(selectedImagePath!);
                              // TODO ask about this warning
                              Routemaster.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("No Image Captured !"),
                              ));
                            }
                          },
                          child: Card(
                              color: Palette.textInputBackground,
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/Camera.png',
                                      height: 60.w,
                                      width: 60.w,
                                    ),
                                    Text(
                                      AppStrings.choosePhtoFromCamera,
                                      style: TextStyleUtil.chooseImageTextStyle,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
