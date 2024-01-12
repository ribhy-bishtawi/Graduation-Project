import 'package:flutter/material.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/features/auth/models/user.dart';
import 'package:grad_proj/features/auth/view_models/auth_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';

import '../../../widgets/GenderSelector.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  void navigateToLoginPage(BuildContext context) {
    Routemaster.of(context).replace('/login');
  }

  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  late FirebaseViewModel firebaseProvider;
  late AuthViewModel authProvider;

  bool _hasPhoneNumber = false;
  bool _hasUsername = false;
  bool _hasGender = false;
  Gender? _gender;
  bool isChecked = false;
  String _phoneNumber = "";
  String _username = "";
  bool isCheckedMale = false;
  bool isCheckedFemale = false;

  late User userData;

  Gender parseGender(String genderString) {
    switch (genderString) {
      case 'Gender.male':
        isCheckedMale = true;
        return Gender.male;
      case 'Gender.female':
        isCheckedFemale = true;
        return Gender.female;
      // Handle other cases if needed
      default:
        throw ArgumentError('Invalid gender string: $genderString');
    }
  }

  @override
  void initState() {
    super.initState();
    firebaseProvider = Provider.of<FirebaseViewModel>(context, listen: false);
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    userData = firebaseProvider.userData;
    _usernameController.text = userData.userName!;
    _phoneNumberController.text = userData.phoneNumber!;
    Gender parsedGender = parseGender(userData.gender!);
    _gender = parsedGender;
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text(
          AppStrings.profilePageTitle,
          style: TextStyleUtil.titleTextStyle,
        ),
        backgroundColor: Palette.whiteColor,
      ),
      backgroundColor: Palette.whiteColor,
      // fixes content overflow when keyboard is opened
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
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
                      CustomTextField(
                        onChanged: (value) => onPhoneNumberChange(value),
                        textFieldController: _phoneNumberController,
                        hintText: AppStrings.phoneHint,
                        icon: Icons.phone,
                        isNumerical: true,
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
                        onPressed: _hasPhoneNumber || _hasUsername || _hasGender
                            ? () => {
                                  authProvider.updateUser(User(
                                      userName: _usernameController.text,
                                      type: "store_owner",
                                      phoneNumber:
                                          _phoneNumberController.text)),
                                  firebaseProvider.updateField(
                                      _phoneNumberController.text,
                                      _gender.toString()),
                                }
                            : null,
                        style: ButtonStyles.primaryButtonStyle,
                        child: Text(
                          AppStrings.shopInformationSaveButton,
                          style: TextStyleUtil.buttonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
