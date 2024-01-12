import 'package:flutter/material.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class CustomFormButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed; // Function parameter

  const CustomFormButton(
      {super.key, required this.text, required this.onPressed});

  @override
  State<CustomFormButton> createState() => _CustomFormButtonState();
}

class _CustomFormButtonState extends State<CustomFormButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyles.addShopInformationButtonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: TextStyleUtil.addShopInputTextStyle,
            ),
            const Icon(
              Icons.arrow_forward, // Replace with your desired icon
              color: Colors.grey, // Icon color
            ),
          ],
        ));
  }
}
