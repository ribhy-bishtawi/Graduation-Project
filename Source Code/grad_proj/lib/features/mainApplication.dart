import 'package:flutter/material.dart';
import 'package:grad_proj/features/notification/screens/notification.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/core/network/apis_constants.dart';
import 'package:grad_proj/features/accounts/screens/settings_screen.dart';
import 'package:grad_proj/features/shops/models/Shop.dart';
import 'package:grad_proj/features/shops/screens/shops.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

import '../resources/app_strings.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var selectedIndex = 0;

  @override
  void initState() {
    final provider = Provider.of<ShopsViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.shops = await provider.fetchAll(
          APIsConstants.shops, "entitys", Shop.fromJson, provider.shops,
          preventLoading: true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    List<Widget> pages = <Widget>[
      Shops(),
      Notifications(),
      Notifications(),
      Settings()
    ];

    List<BottomNavigationBarItem> destinations = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        label: AppStrings.shops,
        icon: const Icon(Icons.home),
      ),
      BottomNavigationBarItem(
          label: AppStrings.offers, icon: const Icon(Icons.discount)),
      BottomNavigationBarItem(
          label: AppStrings.notifications,
          icon: const Icon(Icons.notifications)),
      BottomNavigationBarItem(
          label: AppStrings.account, icon: const Icon(Icons.person)),
    ];

    void onPageChanged(int index) {
      setState(() {
        selectedIndex = index;
        pageController.jumpToPage(
          index,
        );
      });
    }

    return Scaffold(
      body:
          // SafeArea(child: Consumer<ShopsViewModel>(
          //   builder: (BuildContext context, ShopsViewModel shopsViewModel,
          //       Widget? child) {
          //     return Text(shopsViewModel.loading.toString());
          //   },
          // )),
          PageView(
        controller: pageController,
        onPageChanged: (index) {
          onPageChanged(index);
        },
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: destinations,
        currentIndex: selectedIndex,
        selectedIconTheme: const IconThemeData(color: Palette.primary),
        unselectedIconTheme: const IconThemeData(color: Palette.secondary),
        showUnselectedLabels: true,
        unselectedItemColor: Palette.secondary,
        selectedItemColor: Palette.primary,
        selectedLabelStyle: TextStyleUtil.selectedLabelStyle,
        unselectedLabelStyle: TextStyleUtil.unselectedLabelStyle,
        onTap: (int index) {
          onPageChanged(index);
        },
      ),
    );
  }
}

class Destination {
  const Destination(this.index, this.title, this.icon);

  final int index;
  final String title;
  final IconData icon;
}
