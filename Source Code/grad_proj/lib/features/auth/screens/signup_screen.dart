import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/features/auth/models/user.dart';
import 'package:grad_proj/features/auth/view_models/auth_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/features/auth/screens/login_screen.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomRadioButton.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';

import '../../../widgets/GenderSelector.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  void navigateToLoginPage(BuildContext context) {
    Routemaster.of(context).replace('/login');
  }

  void navigateToOTPPage(BuildContext context) {
    Routemaster.of(context).replace('/OTPScreen');
  }

  late FirebaseViewModel firebaseProvider;
  late AuthViewModel authProvider;

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _hasPhoneNumber = false;
  bool _hasUsername = false;
  bool _hasGender = false;
  Gender? _gender;
  bool isChecked = false;
  String _phoneNumber = "";
  String _username = "";
  bool isCheckedMale = false;
  bool isCheckedFemale = false;
  var isUserExist = false;

  @override
  void initState() {
    firebaseProvider = Provider.of<FirebaseViewModel>(context, listen: false);
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authProvider.loginToSuperUser();
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    firebaseProvider = Provider.of<FirebaseViewModel>(context, listen: true);
    authProvider = Provider.of<AuthViewModel>(context, listen: true);

    void onPhoneNumberChange(String newText) {
      setState(() {
        _hasPhoneNumber = newText.isNotEmpty;
        _phoneNumber = newText;
      });
    }

    void onUsernameChange(String newText) {
      setState(() {
        _hasUsername = newText.isNotEmpty;
        _username = newText;
      });
    }

    return Scaffold(
      backgroundColor: Palette.whiteColor,
      // fixes content overflow when keyboard is opened
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: authProvider.mainFormKey,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.signupScreenHeader,
                        style: loginTheme.textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomTextField(
                        onChanged: (value) => onPhoneNumberChange(value),
                        textFieldController: _phoneNumberController,
                        hintText: AppStrings.phoneHint,
                        icon: Icons.phone,
                        isNumerical: true,
                        isIconNeeded: true,
                        changeColorOnUnfocused: true,
                      ),
                      Visibility(
                          visible: firebaseProvider.isUserExist,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 0),
                            child: Text(
                              AppStrings.phoneAlreadyRegistered,
                              style: TextStyleUtil.errorTextStyle,
                            ),
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        // validator: emailValidator,
                        onChanged: (value) => onUsernameChange(value),
                        textFieldController: _usernameController,
                        hintText: AppStrings.usernameHint,
                        icon: Icons.person,
                        isNumerical: false,
                        isIconNeeded: true,
                        changeColorOnUnfocused: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GenderSelector(
                        isCheckedFemale: isCheckedFemale,
                        isCheckedMale: isCheckedMale,
                        onGenderChange: (gender) {
                          setState(
                            () {
                              _gender = gender;
                              _hasGender = _gender != null;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      ElevatedButton(
                          onPressed: _hasPhoneNumber &&
                                  _hasUsername &&
                                  _hasGender
                              ? () async => {
                                    isUserExist =
                                        await firebaseProvider.signUpWithOTP(
                                            _phoneNumberController.text.trim(),
                                            _usernameController.text,
                                            _gender!),
                                    if (!isUserExist)
                                      {
                                        authProvider.userRegister(User(
                                            userName: _usernameController.text,
                                            password: "123456",
                                            type: "store_owner",
                                            phoneNumber:
                                                _phoneNumberController.text)),
                                        authProvider.phoneNum =
                                            _phoneNumberController.text,
                                        if (mounted) navigateToOTPPage(context),
                                      }
                                  }
                              : null,
                          style: ButtonStyles.primaryButtonStyle,
                          child: Text(
                            AppStrings.signup,
                            style: TextStyleUtil.buttonTextStyle,
                          )),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            AppStrings.or,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Palette.secondaryTextColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Almarai",
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ]),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          navigateToLoginPage(context),
                        },
                        style: ButtonStyles.secondaryButtonStyle,
                        child: Text(
                          AppStrings.login,
                          style: TextStyleUtil.secondaryButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 41),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: AppStrings.privacyPolicyAcceptanceOne,
                      style: TextStyleUtil.regularTextStyle
                          .copyWith(fontSize: 14)),
                  TextSpan(
                      text: AppStrings.privacyPolicyAcceptanceTwo,
                      style: TextStyleUtil.linkStyle),
                  TextSpan(
                      text: AppStrings.privacyPolicyAcceptanceThree,
                      style:
                          TextStyleUtil.regularTextStyle.copyWith(fontSize: 14))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
