import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grad_proj/features/notification/screens/add_notification.dart';
import 'package:grad_proj/features/notification/view_models/notification_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/widgets/NotificationCart.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/features/shops/models/Shop.dart';
import 'package:grad_proj/features/shops/screens/delete_shop.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/widgets/ShopCard.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/text_style_util.dart';
import 'package:grad_proj/features/notification/models/notification.dart'
    as model;

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  SlidingUpPanelController deleteShopPanelController =
      SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationViewModel>(
      builder: (BuildContext context,
          NotificationViewModel notificationViewModel, Widget? child) {
        return Stack(children: [
          Scaffold(
            appBar: AppBar(
              // title: Text(AppStrings.shops),
              title: Text(AppStrings.notificationScreenTitile),
              backgroundColor: Palette.scaffoldBackground,
              titleTextStyle: TextStyleUtil.titleTextStyle,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Palette.scaffoldBackground,
            body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                      notificationViewModel.pagingController.refresh),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Constants.padding20),
                    child: PagedListView(
                      pagingController: notificationViewModel.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<
                              model.Notification>(
                          animateTransitions: true,
                          itemBuilder: (BuildContext context,
                              model.Notification item, int index) {
                            return notificationViewModel.notifications.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Constants.padding20),
                                    child: Column(
                                      children: [
                                        Constants.gapH130,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/notification_is_empty.svg',
                                              width: 218.w,
                                              height: 162.w,
                                            ),
                                          ],
                                        ),
                                        Constants.gapH20,
                                        Text(
                                          AppStrings.noNotifications,
                                          style: TextStyleUtil
                                              .notificationScreenText,
                                          textAlign: TextAlign.center,
                                        ),
                                        Constants.gapH20,
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AddNotifiaction()));
                                          },
                                          style:
                                              ButtonStyles.primaryButtonStyle,
                                          child: Text(
                                            AppStrings.addNewNotification,
                                            style:
                                                TextStyleUtil.buttonTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : NotificationCard(
                                    title: item.englishTitle.toString(),
                                    description: item.englishDescription ??
                                        "No description",
                                  );
                          }),
                    ),
                  )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNotifiaction()));
                ;
              },
              backgroundColor: Palette.primary,
              label: Text(
                AppStrings.addNewNotification,
                style: TextStyleUtil.buttonTextStyle,
              ),
            ),
          ),
        ]);
      },
    );
  }
}
