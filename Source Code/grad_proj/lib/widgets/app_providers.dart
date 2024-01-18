import 'package:flutter/material.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/features/Offers/view_models/offer_view_model.dart';
import 'package:grad_proj/features/auth/view_models/auth_view_model.dart';
import 'package:grad_proj/features/notification/view_models/notification_view_model.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopsViewModel()),
        ChangeNotifierProvider(create: (_) => FirebaseViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => OfferViewModel()),
      ],
      child: child,
    );
  }
}
