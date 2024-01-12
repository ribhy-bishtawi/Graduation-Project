import 'package:flutter/material.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class SettingsCard extends StatelessWidget {
  final String settingName;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsCard(
      {super.key,
      required this.settingName,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Palette.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(Constants.padding4),
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: 4),
          leading: Container(
            padding: EdgeInsets.all(Constants.padding8),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Palette.textInputBackground),
            child: Icon(icon, color: Palette.settingsIconTint),
          ),
          title: Text(
            settingName,
            style: TextStyleUtil.regularTextStyle,
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}
