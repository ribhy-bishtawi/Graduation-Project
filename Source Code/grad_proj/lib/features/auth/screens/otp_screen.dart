// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/features/Offers/models/offer.dart';
import 'package:grad_proj/features/Offers/view_models/offer_view_model.dart';
import 'package:grad_proj/features/auth/view_models/auth_view_model.dart';
import 'package:grad_proj/features/notification/view_models/notification_view_model.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:pinput/pinput.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late FirebaseViewModel firebaseProvider;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var userData;
  bool _pinputCompleted = false;
  var username;
  @override
  void initState() {
    firebaseProvider = Provider.of<FirebaseViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel authProvider =
        Provider.of<AuthViewModel>(context, listen: true);
    ShopsViewModel shopProvider =
        Provider.of<ShopsViewModel>(context, listen: false);
    NotificationViewModel notificationProvider =
        Provider.of<NotificationViewModel>(context, listen: true);
    OfferViewModel offerProvider =
        Provider.of<OfferViewModel>(context, listen: true);
    void onPinpunCompleted() {
      setState(() {
        _pinputCompleted = true;
      });
    }

    void onPinpunChange(String newText) {
      setState(() {
        print(newText);
        _pinputCompleted = _pinputCompleted ? newText.length == 5 : false;
      });
    }

    const TextStyle buttonTextStyle = TextStyle(
      fontSize: 16,
      color: Palette.whiteColor,
      fontWeight: FontWeight.w400,
      fontFamily: "Almarai",
    );
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 24,
        color: Palette.black,
        fontFamily: "Almarai",
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        shape: BoxShape.rectangle,
        color: Palette.otpInputBackground,
      ),
    );

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30),
            const SizedBox(height: 8),
            Text(
              AppStrings.otpScreenTitle,
              style: TextStyle(
                  color: Palette.textInputHintColor.withOpacity(1),
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  fontFamily: "Almarai"),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.otpScreenDescription,
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Almarai",
                      fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () => {},
                  // onPressed: () => snackBar("OTP resend!!"),
                  child: Text(
                    authProvider.phoneNum!,
                    style: const TextStyle(
                        color: Palette.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        fontFamily: "Almarai"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '00:55',
              style: TextStyle(
                  color: Palette.textInputHintColor.withOpacity(1),
                  fontWeight: FontWeight.w400,
                  fontSize: 44,
                  fontFamily: "Almarai"),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            firebaseProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Pinput(
                          length: 6,
                          controller: pinController,
                          focusNode: focusNode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (index) =>
                              const SizedBox(width: 10),

                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) async {
                            username =
                                await firebaseProvider.verifyOTP(otp: pin);
                            if (firebaseProvider.isVerified) {
                              if (username != null) {
                                userData =
                                    await authProvider.loginToUser(username);
                                shopProvider.userID = userData.data["userId"];
                                shopProvider.userToken = userData.data["token"];
                                notificationProvider.userID =
                                    userData.data["userId"];
                                notificationProvider.userToken =
                                    userData.data["token"];
                                offerProvider.userToken =
                                    userData.data["token"];
                                firebaseProvider.changeUserStatus();
                              }

                              if (mounted) Routemaster.of(context).replace('/');
                            } else {
                              print("Not");
                            }
                            onPinpunCompleted();
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                            onPinpunChange(value);
                          },
                          focusedPinTheme: defaultPinTheme.copyWith(
                            textStyle: defaultPinTheme.textStyle!.copyWith(
                              color: Palette.primary,
                            ),
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: Palette.primary),
                              color: Palette.whiteColor,
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            textStyle: defaultPinTheme.textStyle!.copyWith(
                              color: Palette.black,
                            ),
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(
                                  color: Palette.textInputFocusedBorder),
                              color: Palette.whiteColor,
                            ),
                          ),
                          // errorPinTheme: defaultPinTheme.copyBorderWith(
                          //   border: Border.all(color: Colors.redAccent),
                          // ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: _pinputCompleted ? () => {} : null,
                  style: ButtonStyles.primaryButtonStyle,
                  child: Text(
                    AppStrings.otpScreenCheckButton,
                    style: buttonTextStyle,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.otpScreenResendTextOne,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Almarai",
                      fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () => {},
                  // onPressed: () => snackBar("OTP resend!!"),
                  child: Text(
                    AppStrings.otpScreenResendTextTwo,
                    style: TextStyle(
                        color: Palette.primary.withOpacity(1),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        fontFamily: "Almarai"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
