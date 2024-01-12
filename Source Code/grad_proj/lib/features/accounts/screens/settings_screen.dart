import 'package:flutter/material.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/features/accounts/screens/account_settings.dart';
import 'package:grad_proj/features/accounts/screens/select_language.dart';
import 'package:grad_proj/features/auth/models/user.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/SettingCard.dart';
import 'package:provider/provider.dart';

import '../../../widgets/UserCard.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  late FirebaseViewModel firebaseProvider;
  late User userData;

  String? username;
  String? phoneNumber;
  void navigateToAccountSettingsScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AccountSettingsScreen()));
  }

  void initState() {
    super.initState();
    firebaseProvider = Provider.of<FirebaseViewModel>(context, listen: false);
    userData = firebaseProvider.userData;
    username = userData.userName!;
    phoneNumber = userData.phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Palette.scaffoldBackground),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Palette.scaffoldBackground,
          body: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              UserCard(
                onTap: () {
                  navigateToAccountSettingsScreen();
                },
                phoneNumber: phoneNumber!,
                username: username!,
              ),
              SettingsCard(
                  settingName: AppStrings.language,
                  icon: Icons.language,
                  onTap: () {
                    // await showDialog(
                    //   context: context,
                    //   builder: (context) => const LanguageSelectionScreen(),
                    // );
                    // setState(() {});
                  }),
              SettingsCard(
                  settingName: AppStrings.aboutTheCompany,
                  icon: Icons.info_rounded,
                  onTap: () {}),
              SettingsCard(
                  settingName: AppStrings.privacyPolicy,
                  icon: Icons.abc,
                  onTap: () {}),
              SettingsCard(
                  settingName: AppStrings.termsAndConditions,
                  icon: Icons.abc,
                  onTap: () {}),
              SettingsCard(
                  settingName: AppStrings.contactUs,
                  icon: Icons.support_agent,
                  onTap: () {}),
              SettingsCard(
                  settingName: AppStrings.deleteAccount,
                  icon: Icons.delete,
                  onTap: () {}),
              SettingsCard(
                  settingName: AppStrings.logout,
                  icon: Icons.logout,
                  onTap: () {}),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                      child: Column(
                    children: [
                      Text("v1.0", style: TextStyleUtil.shopDetailsStyle),
                    ],
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
