import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/features/shops/models/Shop.dart';
import 'package:grad_proj/features/shops/screens/delete_shop.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/widgets/ShopCard.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/text_style_util.dart';
import 'add_shop.dart';

class Shops extends StatefulWidget {
  const Shops({super.key});

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  SlidingUpPanelController deleteShopPanelController =
      SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
    void navigateToAddShopsScreen(bool isGetRequest, Shop? shop) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddShopInformation(
            isEditMode: isGetRequest,
            shop: shop,
          ),
        ),
      );
    }

    return Consumer<ShopsViewModel>(
      builder:
          (BuildContext context, ShopsViewModel shopsViewModel, Widget? child) {
        return Stack(children: [
          Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.shops),
              backgroundColor: Palette.scaffoldBackground,
              titleTextStyle: TextStyleUtil.titleTextStyle,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Palette.scaffoldBackground,
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: () =>
                      Future.sync(shopsViewModel.pagingController.refresh),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Constants.padding20),
                    child: PagedListView(
                      pagingController: shopsViewModel.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Shop>(
                          animateTransitions: true,
                          itemBuilder:
                              (BuildContext context, Shop item, int index) {
                            return ShopCard(
                              shopName: item.arabicName,
                              city: item.cityId.toString(),
                              description:
                                  item.arabicDescription ?? "No description",
                              phoneNumber: item.contactNumber ?? "-",
                              address: item.address!,
                              onEditPressed: () {
                                navigateToAddShopsScreen(true, item);
                              },
                              onShopDeletePressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => DeleteShop(
                                          shopId: item.id!,
                                          onCancelClicked: () {
                                            Navigator.of(context).pop();
                                          },
                                          onConfirmDeleteClicked: () {
                                            shopsViewModel
                                                .deleteShopById(item.id!);
                                            Navigator.of(context).pop();
                                          },
                                        ));
                              },
                            );
                          }),
                    ),
                  )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                navigateToAddShopsScreen(false, null);
              },
              backgroundColor: Palette.primary,
              label: Text(
                AppStrings.addNewShop,
                style: TextStyleUtil.buttonTextStyle,
              ),
            ),
          ),
        ]);
      },
    );
  }
}
