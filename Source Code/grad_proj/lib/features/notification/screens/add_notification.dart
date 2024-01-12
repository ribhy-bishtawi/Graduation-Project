import 'package:flutter/material.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/auth/models/user.dart';
import 'package:grad_proj/features/notification/view_models/notification_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';
import 'package:grad_proj/features/notification/models/notification.dart'
    as model;
import 'package:routemaster/routemaster.dart';

class AddNotifiaction extends StatefulWidget {
  const AddNotifiaction({super.key});

  @override
  State<AddNotifiaction> createState() => _AddNotifiactionState();
}

class _AddNotifiactionState extends State<AddNotifiaction> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _englishTitileController =
      TextEditingController();
  final TextEditingController _englishDescriptionController =
      TextEditingController();
  late NotificationViewModel notificationProvider;

  bool _hasDescription = false;
  bool _hasTitle = false;
  late User userData;
  int wordCount = 0;

  @override
  void initState() {
    super.initState();
    notificationProvider =
        Provider.of<NotificationViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    void onDescriptionChange(String newText) {
      setState(() {
        _hasDescription = newText.isNotEmpty;
      });
    }

    void onTitileChange(String newText) {
      setState(() {
        _hasTitle = newText.isNotEmpty;
      });
    }

    void updateWordCount(String value) {
      // Count words by splitting the text into a list of words
      String textWithoutSpaces = value.replaceAll(' ', '');
      // Remove any empty strings resulting from multiple spaces
      // Update  word count
      setState(() {
        wordCount = textWithoutSpaces.length;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.addNotificationScreenTitle,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.addNotificationScreenHeader,
                        style: TextStyleUtil.addNotificationScreenText,
                        textAlign: TextAlign.left,
                      ),
                      Constants.gapH20,
                      CustomTextField(
                        onChanged: (value) {
                          onTitileChange(value);
                        },
                        textFieldController: _englishTitileController,
                        hintText:
                            AppStrings.addNotificationScreenTitleFieldHint,
                        icon: Icons.person,
                        isNumerical: false,
                        isIconNeeded: false,
                        changeColorOnUnfocused: true,
                        textStyle: TextStyleUtil.addNotificationScreenText,
                      ),
                      Constants.gapH12,
                      CustomTextField(
                        maxLines: 4,
                        isSmallCircularBorder: true,
                        onChanged: (value) {
                          onDescriptionChange(value);
                          updateWordCount(value);
                        },
                        textFieldController: _englishDescriptionController,
                        hintText: AppStrings
                            .addNotificationScreenDescriptionFieldHint,
                        icon: Icons.phone,
                        isNumerical: true,
                        isIconNeeded: false,
                        changeColorOnUnfocused: true,
                        textStyle: TextStyleUtil.addNotificationScreenText,
                      ),
                      Constants.gapH12,
                      Text("$wordCount / 200"),
                      Constants.gapH24,
                      ElevatedButton(
                        onPressed: _hasDescription && _hasTitle
                            ? () async => {
                                  await notificationProvider.addNotification(
                                      model.Notification(
                                          arabicTitle: "فش",
                                          arabicDescription: "فش",
                                          englishTitle:
                                              _englishTitileController.text,
                                          englishDescription:
                                              _englishDescriptionController
                                                  .text)),
                                  if (mounted) Routemaster.of(context).pop(),
                                }
                            : null,
                        style: ButtonStyles.primaryButtonStyle,
                        child: Text(
                          AppStrings.addNotificationScreenSendButton,
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
