import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/features/Offers/models/offer.dart';
import 'package:grad_proj/features/Offers/view_models/offer_view_model.dart';
import 'package:grad_proj/features/auth/models/user.dart';
import 'package:grad_proj/features/notification/view_models/notification_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/widgets/CustomFormButton.dart';
import 'package:provider/provider.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';
import 'package:grad_proj/features/notification/models/notification.dart'
    as model;
import 'package:routemaster/routemaster.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({super.key});

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _englishTitileController =
      TextEditingController();
  final TextEditingController _englishDescriptionController =
      TextEditingController();
  late OfferViewModel offerProvider;
  DateTime? _offerStartDate;
  DateTime? _offerEndDate;
  String? _toPrintOfferStartDate;
  String? _toPrintOfferEndDate;
  String? _formattedOfferStartDate;
  String? _formattedOfferEndDate;

  bool _hasDescription = false;
  bool _hasTitle = false;
  late User userData;
  int wordCount = 0;

  @override
  void initState() {
    super.initState();
    offerProvider = Provider.of<OfferViewModel>(context, listen: false);
  }

  void _showStartDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _offerStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2027),
    ).then((value) => {
          if (value != null)
            {
              setState(() {
                _offerStartDate = value;
                _formattedOfferStartDate =
                    DateFormat('yyyy-MM-dd').format(_offerStartDate!);
                _toPrintOfferStartDate =
                    DateFormat('dd-MM-yyyy').format(_offerStartDate!);
              })
            }
        });
  }

  void _showEndDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _offerEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2027),
    ).then((value) => {
          if (value != null)
            {
              setState(() {
                _offerEndDate = value;
                _formattedOfferEndDate =
                    DateFormat('yyyy-MM-dd').format(_offerEndDate!);
                _toPrintOfferEndDate =
                    DateFormat('dd-MM-yyyy').format(_offerEndDate!);
              })
            }
        });
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
          AppStrings.addNewOfferTitle,
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
                        AppStrings.offerNameHint,
                        style: TextStyleUtil.addNotificationScreenText,
                        textAlign: TextAlign.left,
                      ),
                      Constants.gapH12,
                      CustomTextField(
                        onChanged: (value) {
                          onTitileChange(value);
                        },
                        textFieldController: _englishTitileController,
                        hintText: AppStrings.offerNameHint,
                        icon: Icons.person,
                        isNumerical: false,
                        isIconNeeded: false,
                        changeColorOnUnfocused: true,
                        textStyle: TextStyleUtil.addNotificationScreenText,
                      ),
                      Constants.gapH12,
                      Text(
                        AppStrings.offerStartDateHint,
                        style: TextStyleUtil.addNotificationScreenText,
                        textAlign: TextAlign.left,
                      ),
                      Constants.gapH12,
                      CustomFormButton(
                          text: _toPrintOfferStartDate != null
                              ? _toPrintOfferStartDate!
                              : AppStrings.offerStartDateHint,
                          onPressed: () => _showStartDatePicker()),
                      Constants.gapH12,
                      Text(
                        AppStrings.offerEndDateHint,
                        style: TextStyleUtil.addNotificationScreenText,
                        textAlign: TextAlign.left,
                      ),
                      Constants.gapH12,
                      CustomFormButton(
                          text: _toPrintOfferEndDate != null
                              ? _toPrintOfferEndDate!
                              : AppStrings.offerEndDateHint,
                          onPressed: () => _showEndDatePicker()),
                      Constants.gapH12,
                      Text(
                        AppStrings.offerDescriptionHint,
                        style: TextStyleUtil.addNotificationScreenText,
                        textAlign: TextAlign.left,
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
                        hintText: AppStrings.offerDescriptionHint,
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
                        onPressed: _hasDescription &&
                                _hasTitle &&
                                _formattedOfferStartDate != null &&
                                _formattedOfferEndDate != null
                            ? () async => {
                                  await offerProvider.addOffer(
                                    Offer(
                                      arabicTitle: "No",
                                      englishTitle:
                                          _englishTitileController.text,
                                      englishDescription:
                                          _englishDescriptionController.text,
                                      imageName: "No",
                                      startDate: _formattedOfferStartDate,
                                      endDate: _formattedOfferEndDate,
                                    ),
                                  ),
                                  if (mounted) Routemaster.of(context).pop(),
                                }
                            : null,
                        style: ButtonStyles.primaryButtonStyle,
                        child: Text(
                          AppStrings.offerPageAddOfferButton,
                          style: TextStyleUtil.buttonTextStyle,
                        ),
                      ),
                      Constants.gapH24,
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
