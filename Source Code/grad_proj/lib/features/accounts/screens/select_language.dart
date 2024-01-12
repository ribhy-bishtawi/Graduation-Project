import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Select Language'),
      children: [
        SimpleDialogOption(
          onPressed: () {
            _changeLanguage(context, 'en');
          },
          child: Text('English'),
        ),
        SimpleDialogOption(
          onPressed: () {
            _changeLanguage(context, 'ar');
          },
          child: Text('Arabic'),
        ),
        SimpleDialogOption(
          onPressed: () {
            _changeLanguage(context, 'tr');
          },
          child: Text('Turkish'),
        ),
      ],
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    setState(() {
      context.setLocale(Locale(languageCode));
    });
    Navigator.pop(context); // Close the language selection dialog
  }
}
