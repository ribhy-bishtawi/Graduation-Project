import 'package:flutter/material.dart';
import 'package:grad_proj/features/auth/screens/entry_screen.dart';
import 'package:grad_proj/features/auth/screens/otp_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/features/accounts/screens/settings_screen.dart';
import 'package:grad_proj/features/auth/screens/login_screen.dart';
import 'package:grad_proj/features/auth/screens/signup_screen.dart';
import 'package:grad_proj/features/mainApplication.dart';
import 'package:grad_proj/features/shops/screens/add_shop.dart';
import 'package:grad_proj/features/shops/screens/choose_location.dart';

final loggedOutRoute = RouteMap(
  routes: {
    // '/': (_) => MaterialPage(child: Shops()),
    '/': (_) => const MaterialPage(child: EntryScreen()),
    '/OTPScreen': (_) => const MaterialPage(child: OTPScreen()),
    '/login': (_) => const MaterialPage(child: LoginScreen()),
    '/signup': (_) => const MaterialPage(child: SignupScreen()),
    '/shops': (_) => const MaterialPage(child: MainApp()),
    '/add_shops': (_) => MaterialPage(
            child: AddShopInformation(
          isEditMode: false,
        )),
    '/accounts': (_) => const MaterialPage(child: Settings()),

    '/map/:isEditMode': (RouteData data) {
      final passedVariable = data.pathParameters['isEditMode'];
      final isEditMode = passedVariable == "true";
      return MaterialPage(
        child: ChooseLocation(
          isEditMode: isEditMode,
          address: null,
          mapValueToChangeInEditMode: null,
        ),
      );
    }
  },

  // '/choose_image': (_) => MaterialPage(child: ChoosePhoto()),
);
final loggedInRoute = RouteMap(
  routes: {
    // '/': (_) => MaterialPage(child: Shops()),
    '/': (_) => const MaterialPage(child: MainApp()),
    '/OTPScreen': (_) => const MaterialPage(child: OTPScreen()),
    '/login': (_) => const MaterialPage(child: LoginScreen()),
    '/signup': (_) => const MaterialPage(child: SignupScreen()),
    '/shops': (_) => const MaterialPage(child: MainApp()),
    '/add_shops': (_) => MaterialPage(
            child: AddShopInformation(
          isEditMode: false,
        )),
    '/accounts': (_) => const MaterialPage(child: Settings()),

    '/map/:isEditMode': (RouteData data) {
      final passedVariable = data.pathParameters['isEditMode'];
      final isEditMode = passedVariable == "true";
      return MaterialPage(
        child: ChooseLocation(
          isEditMode: isEditMode,
          address: null,
          mapValueToChangeInEditMode: null,
        ),
      );
    }
  },

  // '/choose_image': (_) => MaterialPage(child: ChoosePhoto()),
);
