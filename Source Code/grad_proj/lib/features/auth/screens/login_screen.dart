import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/features/auth/view_models/auth_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FirebaseViewModel firebaseProvider;
  late AuthViewModel authProvider;

  void navigateToSignup(BuildContext context) {
    Routemaster.of(context).replace('/signup');
  }

  void navigateToOTPPage(BuildContext context) {
    Routemaster.of(context).replace('/OTPScreen');
  }

  @override
  void initState() {
    // TODO: implement initState
    firebaseProvider = Provider.of<FirebaseViewModel>(context, listen: false);
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authProvider.loginToSuperUser();
      ;
    });

    super.initState();
  }

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumController = TextEditingController();
  bool isUserExist = false;
  bool isUserLoggedIn = false;

  bool _isButtonEnabled = false;

  // TODO: pass this from previous page
  String _phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    firebaseProvider = Provider.of<FirebaseViewModel>(context, listen: true);
    authProvider = Provider.of<AuthViewModel>(context, listen: true);

    void onTextFieldChangeCallback(String newText) {
      setState(() {
        _isButtonEnabled = newText.isNotEmpty;
      });
    }

    return Scaffold(
      backgroundColor: Palette.whiteColor,
      body: GestureDetector(
          onTap: () {},
          child: SizedBox(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.loginScreenHeader,
                  style: loginTheme.textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  validator: customValidator,
                  onChanged: (value) => onTextFieldChangeCallback(value),
                  textFieldController: _phoneNumController,
                  hintText: AppStrings.phoneHint,
                  icon: Icons.phone,
                  textStyle: TextStyleUtil.regularTextStyle,
                  isNumerical: true,
                  isIconNeeded: true,
                  changeColorOnUnfocused: true,
                ),

                Visibility(
                    visible: firebaseProvider.userNotExist,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 0),
                      child: Text(
                        AppStrings.phoneNotRegistered,
                        style: TextStyleUtil.errorTextStyle,
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                // TODO: this tertiary operator is unnecessary, remove it.
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () async => {
                            isUserLoggedIn = await firebaseProvider
                                .loginWithOTP(_phoneNumController.text),
                            authProvider.phoneNum = _phoneNumController.text,
                            if (isUserLoggedIn)
                              if (mounted) navigateToOTPPage(context),
                          }
                      : null,
                  style: ButtonStyles.primaryButtonStyle,
                  child: Text(
                    AppStrings.login,
                    style: TextStyleUtil.buttonTextStyle,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(children: <Widget>[
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      AppStrings.or,
                      style: TextStyleUtil.regularTextStyle,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    onPressed: () => navigateToSignup(context),
                    style: ButtonStyles.secondaryButtonStyle,
                    child: Text(
                      AppStrings.signup,
                      style: TextStyleUtil.secondaryButtonTextStyle,
                    )),
              ],
            ),
          ))),
    );
  }

  String? customValidator(String? fieldContent) {
    if (fieldContent == null || fieldContent.isEmpty) {
      return 'error!';
    }
    return null; // No error
  }
}

// TODO: figure out a way to remove this or move into a different file
var loginTheme = ThemeData.light().copyWith(
    hintColor: Palette.textInputHintColor,
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontSize: 16,
        color: Palette.textInputText,
        fontFamily: "Almarai",
      ),
      bodyLarge: TextStyle(
          fontSize: 24,
          color: Palette.textInputText,
          fontFamily: "Almarai",
          fontWeight: FontWeight.w700),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size.fromHeight(48),
        disabledBackgroundColor: Palette.primaryButtonDisabledBackground,
        backgroundColor: Palette.primary,
      ),
    ));
