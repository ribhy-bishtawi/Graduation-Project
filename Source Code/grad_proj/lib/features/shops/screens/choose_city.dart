import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/shops/models/City.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';

class ChooseCity extends StatefulWidget {
  const ChooseCity({super.key});

  @override
  State<ChooseCity> createState() => _ChooseCityState();
}

class _ChooseCityState extends State<ChooseCity> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopsViewModel>(context);
    List<City> cities = provider.cities;
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
            AppStrings.chooseCityTitle,
            style: TextStyleUtil.chooseScreensTextStyle,
          ),
          Constants.gapH28,
          CustomTextField(
            onChanged: (value) {},
            textFieldController: editingController,
            hintText: AppStrings.chooseCitySearchBarHint,
            textStyle: TextStyleUtil.addShopInputTextStyle,
            isIconNeeded: true,
            icon: Icons.search,
          ),
          Constants.gapH28,
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${cities[index].arabicName}',
                    style: TextStyleUtil.chooseScreensTextStyle,
                  ),
                  trailing: cities[index].isSelected
                      ? Icon(Icons.check,
                          color: const Color(0x11121212).withOpacity(1))
                      : null,
                  onTap: () {
                    setState(() {
                      cities[index].isSelected = !cities[index].isSelected;
                      Provider.of<ShopsViewModel>(context, listen: false)
                          .toggleCityIsChecked(cities[index].isSelected);
                    });
                  },
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
