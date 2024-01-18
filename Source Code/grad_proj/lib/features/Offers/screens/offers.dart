import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:grad_proj/features/Offers/models/offer.dart';
import 'package:grad_proj/features/Offers/screens/add_offer.dart';
import 'package:grad_proj/features/Offers/screens/delete_offer.dart';
import 'package:grad_proj/features/Offers/view_models/offer_view_model.dart';
import 'package:grad_proj/features/shops/screens/delete_shop.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/widgets/OfferCard.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/theme/palette.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/text_style_util.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  SlidingUpPanelController deleteShopPanelController =
      SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferViewModel>(
      builder:
          (BuildContext context, OfferViewModel offerViewModel, Widget? child) {
        return Stack(children: [
          Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.offerPageTitle),
              backgroundColor: Palette.scaffoldBackground,
              titleTextStyle: TextStyleUtil.titleTextStyle,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Palette.scaffoldBackground,
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: () =>
                      Future.sync(offerViewModel.pagingController.refresh),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Constants.padding20),
                    child: PagedListView(
                      pagingController: offerViewModel.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Offer>(
                          animateTransitions: true,
                          itemBuilder:
                              (BuildContext context, Offer item, int index) {
                            return
                                //  offerViewModel.offers.isEmpty
                                // ? Padding(
                                //     padding: EdgeInsets.symmetric(
                                //         horizontal: Constants.padding20),
                                //     child: Column(
                                //       children: [
                                //         Constants.gapH130,
                                //         Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.center,
                                //           children: [
                                //             SvgPicture.asset(
                                //               'assets/images/notification_is_empty.svg',
                                //               width: 218.w,
                                //               height: 162.w,
                                //             ),
                                //           ],
                                //         ),
                                //         Constants.gapH20,
                                //         Text(
                                //           AppStrings.noNotifications,
                                //           style: TextStyleUtil
                                //               .notificationScreenText,
                                //           textAlign: TextAlign.center,
                                //         ),
                                //         Constants.gapH20,
                                //         ElevatedButton(
                                //           onPressed: () {
                                //             Navigator.push(
                                //                 context,
                                //                 MaterialPageRoute(
                                //                     builder: (context) =>
                                //                         const AddNotifiaction()));
                                //           },
                                //           style:
                                //               ButtonStyles.primaryButtonStyle,
                                //           child: Text(
                                //             AppStrings.addNewNotification,
                                //             style:
                                //                 TextStyleUtil.buttonTextStyle,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   )
                                // :
                                OfferCard(
                              offer: item,
                              onShopDeletePressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => DeleteOffer(
                                          offerID: item.id!,
                                          onCancelClicked: () {
                                            Navigator.of(context).pop();
                                          },
                                          onConfirmDeleteClicked: () {
                                            offerViewModel
                                                .deleteOfferById(item.id!);
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddOffer()));
                ;
              },
              backgroundColor: Palette.primary,
              label: Text(
                AppStrings.offerPageAddNewOfferButton,
                style: TextStyleUtil.buttonTextStyle,
              ),
            ),
          ),
        ]);
      },
    );
  }
}
