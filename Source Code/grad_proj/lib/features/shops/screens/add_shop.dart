import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/shops/models/Tag.dart';
import 'package:grad_proj/features/shops/screens/choose_category.dart';
import 'package:grad_proj/features/shops/screens/choose_city.dart';
import 'package:grad_proj/features/shops/screens/choose_location.dart';
import 'package:grad_proj/features/shops/screens/choose_time.dart';
import 'package:grad_proj/features/shops/screens/image_util.dart';
import 'package:grad_proj/features/shops/screens/validators.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomFormButton.dart';
import 'package:grad_proj/widgets/CustomSlidingUpPanel.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';
import 'package:grad_proj/widgets/WrapImages.dart';
import 'package:grad_proj/widgets/WrapText.dart';

import '../models/Shop.dart';

class AddShopInformation extends StatefulWidget {
  final bool isEditMode;
  final Shop? shop;

  AddShopInformation({super.key, required this.isEditMode, this.shop});

  @override
  State<AddShopInformation> createState() => _AddShopInformationState();
}

class _AddShopInformationState extends State<AddShopInformation> {
  late ShopsViewModel provider;

  final TextEditingController _shopNameInArabicController =
      TextEditingController();
  final TextEditingController _shopNameInEnglishController =
      TextEditingController();
  final TextEditingController _commercialRegistrationNoController =
      TextEditingController();
  final TextEditingController _branchNameCotroller = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _facebookLinkController = TextEditingController();
  final TextEditingController _instagramLinkController =
      TextEditingController();
  final TextEditingController _tiktokAccountController =
      TextEditingController();
  final TextEditingController _hintWordController = TextEditingController();

  SlidingUpPanelController categoryPanelController = SlidingUpPanelController();
  SlidingUpPanelController cityPanelController = SlidingUpPanelController();
  SlidingUpPanelController timePanelController = SlidingUpPanelController();

  String postOrEditModeText(String postText, String? editText) {
    if (editText == null) return postText;
    return widget.isEditMode ? editText : postText;
  }

  void setTextFieldInitialValue(
      TextEditingController textController, String? text) {
    if (text == null) return;
    textController.text = text;
  }

  File? selectedImagePath;

  @override
  void initState() {
    provider = Provider.of<ShopsViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.init();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getShopData(widget.shop?.id ?? 0,
          isEditMode: widget.isEditMode);

      if (widget.isEditMode) {
        Shop shop = widget.shop!;
        setTextFieldInitialValue(_shopNameInArabicController, shop.arabicName);
        setTextFieldInitialValue(
            _shopNameInEnglishController, shop.englishName);
        setTextFieldInitialValue(
            _commercialRegistrationNoController, shop.commercialId);
        setTextFieldInitialValue(_branchNameCotroller, shop.englishDescription);
        setTextFieldInitialValue(_phoneNumController, shop.contactNumber);
        setTextFieldInitialValue(_contactNameController, shop.contactName);
        setTextFieldInitialValue(_facebookLinkController, shop.facebookLink);
        setTextFieldInitialValue(_instagramLinkController, shop.instagramLink);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.clearData();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ShopsViewModel>(context, listen: true);
    double minBound = 0;
    double upperBound = 1.0;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              postOrEditModeText(
                  AppStrings.addNewShopTitle, AppStrings.editShopTitle),
              style: TextStyleUtil.titleTextStyle,
              textAlign: TextAlign.right,
            ),
          ),
          body: widget.isEditMode && provider.loading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Form(
                    key: provider.mainFormKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.shopInformation,
                            style: TextStyleUtil.addShopHeaderTextStyle,
                          ),
                          Constants.gapH20,
                          CustomTextField(
                            textFieldController: _shopNameInArabicController,
                            hintText: AppStrings.shopNameInArabic,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                            isIconNeeded: false,
                            validator: Validators.validateShopNameInArabic,
                          ),
                          Constants.gapH16,
                          CustomTextField(
                            textFieldController: _shopNameInEnglishController,
                            hintText: AppStrings.shopNameInEnglish,
                            validator: Validators.validateShopNameInEnglish,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                          ),
                          Constants.gapH16,
                          CustomTextField(
                            textFieldController:
                                _commercialRegistrationNoController,
                            hintText: AppStrings.commercialRegistrationNo,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                          ),
                          Constants.gapH16,
                          provider.addresses.isNotEmpty
                              ? Column(
                                  children:
                                      provider.addresses.entries.map((entry) {
                                  final address = entry.value;
                                  final arabicName = address.arabicName;
                                  return Column(
                                    children: [
                                      CustomFormButton(
                                        text: arabicName!,
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChooseLocation(
                                                      isEditMode:
                                                          widget.isEditMode,
                                                      address: address,
                                                      mapValueToChangeInEditMode:
                                                          entry.key,
                                                    ))),
                                      ),
                                      Constants.gapH16,
                                    ],
                                  );
                                }).toList())
                              : CustomTextField(
                                  textFieldController: _branchNameCotroller,
                                  hintText: AppStrings.noBranch,
                                  textStyle:
                                      TextStyleUtil.addShopInputTextStyle),
                          Constants.gapH12,
                          FractionallySizedBox(
                            alignment: Alignment.topRight,
                            widthFactor: 1 / 3,
                            child: ElevatedButton(
                                onPressed: () {
                                  Routemaster.of(context).push("/map/false");
                                },
                                style: ButtonStyles.addShopBranchButtonStyle,
                                child: Text(
                                  AppStrings.addBranchButton,
                                  style: TextStyleUtil.addShopBranchTextStyle,
                                )),
                          ),
                          Constants.gapH16,
                          CustomFormButton(
                              text: AppStrings.category,
                              onPressed: () {
                                categoryPanelController.expand();
                              }),
                          Visibility(
                              visible: provider.showCategoryValidationError,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 0),
                                child: Text(
                                  AppStrings.requiredFieldErrorMessage,
                                  style: TextStyleUtil.errorTextStyle,
                                ),
                              )),
                          Constants.gapH16,
                          CustomFormButton(
                              text: AppStrings.city,
                              onPressed: () => cityPanelController.expand()),
                          Visibility(
                              visible: provider.showCityValidationError,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 0),
                                child: Text(
                                  AppStrings.requiredFieldErrorMessage,
                                  style: TextStyleUtil.errorTextStyle,
                                ),
                              )),
                          Constants.gapH16,
                          CustomFormButton(
                              text: AppStrings.time,
                              onPressed: () => timePanelController.expand()),
                          Visibility(
                              visible: provider.showDayValidationError,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 0),
                                child: Text(
                                  AppStrings.requiredFieldErrorMessage,
                                  style: TextStyleUtil.errorTextStyle,
                                ),
                              )),
                          Constants.gapH24,
                          Text(
                            AppStrings.contactInformation,
                            style: TextStyleUtil.addShopHeaderTextStyle,
                          ),
                          Constants.gapH20,
                          CustomTextField(
                            textFieldController: _phoneNumController,
                            hintText: AppStrings.phoneNum,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                          ),
                          Constants.gapH16,
                          CustomTextField(
                            textFieldController: _contactNameController,
                            hintText: AppStrings.contactName,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                          ),
                          Constants.gapH24,
                          Text(
                            AppStrings.socialMediaInformation,
                            style: TextStyleUtil.addShopHeaderTextStyle,
                          ),
                          Constants.gapH20,
                          CustomTextField(
                            textFieldController: _facebookLinkController,
                            hintText: AppStrings.facebookLink,
                            validator: Validators.validateFacebookLink,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                          ),
                          Constants.gapH16,
                          CustomTextField(
                            textFieldController: _instagramLinkController,
                            hintText: AppStrings.instagramLink,
                            validator: Validators.validateInstagramLink,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                          ),
                          Constants.gapH16,
                          CustomTextField(
                            textFieldController: _tiktokAccountController,
                            hintText: AppStrings.tiktokAccount,
                            validator: Validators.validateTikTokAccount,
                            textStyle: TextStyleUtil.addShopInputTextStyle,
                          ),
                          Constants.gapH24,
                          Text(
                            AppStrings.hintWordsTitle,
                            style: TextStyleUtil.addShopHeaderTextStyle,
                          ),
                          Constants.gapH20,
                          WrapText(
                            elementsList: provider.mainTags,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomTextField(
                                    textFieldController: _hintWordController,
                                    hintText: AppStrings.hintWord,
                                    textStyle:
                                        TextStyleUtil.addShopInputTextStyle),
                              ),
                              Constants.gapW10,
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        provider.addTag(
                                            Tag(
                                              englishName: "Test",
                                              arabicName:
                                                  _hintWordController.text,
                                            ),
                                            false);
                                        _hintWordController.clear();
                                      });
                                    },
                                    style:
                                        ButtonStyles.addShopBranchButtonStyle,
                                    child: Text(
                                      AppStrings.hintWordAddButton,
                                      style:
                                          TextStyleUtil.addShopBranchTextStyle,
                                    )),
                              ),
                            ],
                          ),
                          Constants.gapH24,
                          Text(
                            AppStrings.shopImage,
                            style: TextStyleUtil.addShopHeaderTextStyle,
                          ),
                          Constants.gapH20,
                          Align(
                            alignment: Alignment.centerRight,
                            child: WrapImages(
                              imagePath: //widget.isEditMode
                                  // ? widget.shop!.profileImage
                                  provider.localImagePath,
                              isEditMode: widget.isEditMode,
                            ),
                          ),
                          FractionallySizedBox(
                            alignment: Alignment.topRight,
                            widthFactor: 1 / 3,
                            child: ElevatedButton(
                                onPressed: () {
                                  ImageUtils.selectImage(context);
                                },
                                style: ButtonStyles.addShopBranchButtonStyle,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Palette.primary,
                                    ),
                                    Text(
                                      AppStrings.shopImageAddButton,
                                      style:
                                          TextStyleUtil.addShopBranchTextStyle,
                                    ),
                                  ],
                                )),
                          ),
                          Constants.gapH28,
                          SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (provider.validateForm()) {
                                    Shop shop = Shop(
                                        cityId: provider.returnSelectedCity()!,
                                        arabicName:
                                            _shopNameInArabicController.text,
                                        englishName:
                                            _shopNameInEnglishController.text,
                                        profileImage:
                                            provider.imagePathToUpload,
                                        commercialId:
                                            _commercialRegistrationNoController
                                                        .text ==
                                                    ""
                                                ? null
                                                : _commercialRegistrationNoController
                                                    .text,
                                        contactNumber:
                                            _phoneNumController.text == ""
                                                ? null
                                                : _phoneNumController.text,
                                        contactName:
                                            _phoneNumController.text == ""
                                                ? null
                                                : _contactNameController.text,
                                        facebookLink:
                                            _phoneNumController.text == ""
                                                ? null
                                                : _facebookLinkController.text,
                                        instagramLink:
                                            _phoneNumController.text == ""
                                                ? null
                                                : _instagramLinkController.text,
                                        tiktokLink:
                                            _phoneNumController.text == ""
                                                ? null
                                                : _tiktokAccountController.text,
                                        type: "store");
                                    widget.isEditMode
                                        ? await provider.updateShop(
                                            shop, widget.shop!.id!)
                                        : await provider.addShop(shop);
                                    if (mounted) Routemaster.of(context).pop();
                                  }
                                },
                                style: ButtonStyles.primaryButtonStyle,
                                child: Text(
                                  AppStrings.shopInformationSaveButton,
                                  style: TextStyleUtil.buttonTextStyle,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
        CustomSlidingUpPanel(
          controlHeight: 50.0,
          anchor: 0.4,
          minimumBound: minBound,
          upperBound: upperBound,
          panelController: categoryPanelController,
          child: ChooseCategory(
            isEditMode: widget.isEditMode,
          ),
        ),
        CustomSlidingUpPanel(
          controlHeight: 50.0,
          anchor: 0.4,
          minimumBound: minBound,
          upperBound: upperBound,
          panelController: cityPanelController,
          child: const ChooseCity(),
        ),
        CustomSlidingUpPanel(
          controlHeight: 20.0,
          anchor: 0.6,
          minimumBound: minBound,
          upperBound: upperBound,
          panelController: timePanelController,
          child: ChooseTime(
            isEditMode: widget.isEditMode,
          ),
        ),
      ],
    );
  }
}
