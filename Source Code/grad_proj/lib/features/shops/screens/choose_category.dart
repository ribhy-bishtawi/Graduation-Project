import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';

class ChooseCategory extends StatefulWidget {
  final bool isEditMode;
  const ChooseCategory({super.key, required this.isEditMode});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  TextEditingController editingController = TextEditingController();

  var items = [];
  var itemsState = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopsViewModel>(context);
    final categoriesList = provider.categories;
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
        children: <Widget>[
          buildDragIcon(),
          Constants.gapH12,
          Text(
            AppStrings.chooseCategoryTitle,
            style: TextStyleUtil.chooseScreensTextStyle,
          ),
          Constants.gapH24,
          CustomTextField(
            onChanged: (value) {},
            textFieldController: editingController,
            hintText: AppStrings.chooseCategorySearchBarHint,
            textStyle: TextStyleUtil.addShopInputTextStyle,
            isIconNeeded: true,
            icon: Icons.search,
          ),
          Constants.gapH20,
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${categoriesList[index].englishName}',
                    style: TextStyleUtil.chooseScreensTextStyle,
                  ),
                  leading: Checkbox(
                    checkColor: Colors.white,
                    activeColor: Palette.primary,
                    value: categoriesList[index].isSelected,
                    shape: const CircleBorder(),
                    side: !categoriesList[index].isSelected
                        ? MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(
                                width: 1.5.w, color: const Color(0xDDDEE2E6)),
                          )
                        : null,
                    onChanged: (bool? value) {
                      provider.toggleCategoryIsChecked(categoriesList[index]);
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Palette.listItemBorder,
                thickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDragIcon() => Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(6.w),
        ),
        width: 38.w,
        height: 4.h,
      );
}
