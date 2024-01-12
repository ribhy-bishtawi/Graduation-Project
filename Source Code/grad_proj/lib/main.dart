import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/router.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/widgets/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    AppProviders(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
          Locale('tr'),
        ],
        path: 'assets/translations',
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseViewModel provider =
        Provider.of<FirebaseViewModel>(context, listen: true);

    context.setLocale(const Locale("en"));
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: Palette.lightModeAppTheme,
          routerDelegate: RoutemasterDelegate(
              routesBuilder: (_) =>
                  provider.isUserLoggedIn ? loggedInRoute : loggedOutRoute),
          routeInformationParser: const RoutemasterParser(),
        );
      },
    );
  }
}
