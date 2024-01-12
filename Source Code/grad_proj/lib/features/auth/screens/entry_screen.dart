import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  void navigateToLoginPage(BuildContext context) {
    Routemaster.of(context).replace('/login');
  }

  void navigateToSignup(BuildContext context) {
    Routemaster.of(context).replace('/signup');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              // Replace with the path to your SVG asset
              'assets/images/EntryScreenLogo.svg',
              width: 148, // Set the desired width
              height: 30.27,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            SvgPicture.asset('assets/images/Ellipse.svg',
                // Replace with the path to your SVG asset
                width: 241, // Set the desired width
                height: 241,
                fit: BoxFit.cover // Set the desired height
                ),
            SizedBox(
              height: height / 35,
            ),
            SvgPicture.asset('assets/images/UpperRec.svg',
                // Replace with the path to your SVG asset
                width: 242, // Set the desired width
                height: 22,
                fit: BoxFit.cover // Set the desired height
                ),
            SizedBox(
              height: height / 50,
            ),
            SvgPicture.asset('assets/images/BottomRec.svg',
                // Replace with the path to your SVG asset
                width: 296, // Set the desired width
                height: 9,
                fit: BoxFit.cover // Set the desired height
                ),
            SizedBox(
              height: height / 15,
            ),
            ElevatedButton(
                onPressed: () => navigateToLoginPage(context),
                style: ButtonStyles.primaryButtonStyle,
                child: Text(
                  AppStrings.login,
                  style: TextStyleUtil.buttonTextStyle,
                )),
            SizedBox(
              height: height / 50,
            ),
            ElevatedButton(
                onPressed: () => navigateToSignup(context),
                style: ButtonStyles.secondaryButtonStyle,
                child: Text(
                  AppStrings.signup,
                  style: TextStyleUtil.secondaryButtonTextStyle,
                )),
          ]),
        ),
      ),
    );
  }
}
