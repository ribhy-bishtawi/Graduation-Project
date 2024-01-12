import 'package:flutter/material.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class UserCard extends StatelessWidget {
  final String username;

  // TODO: get image from api and store it on device
  // File? profilePicture;
  final VoidCallback onTap;
  final String phoneNumber;

  const UserCard(
      {super.key,
      required this.username,
      required this.onTap,
      required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      elevation: 0,
      color: Palette.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        heightFactor: 1.2,
        // TODO:  change this from tile to a custom card so it can have a different height and the inkwell works correctly
        child: ListTile(
          leading: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Palette.primary,
                  width: 1,
                ),
              ),
              // TODO: replace with user pfp
              child: const Image(
                image: AssetImage('assets/images/account_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            username,
            style: TextStyleUtil.titleTextStyle,
          ),
          subtitle: Text(
            phoneNumber,
            style: TextStyleUtil.subtitleTextStyle,
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}
