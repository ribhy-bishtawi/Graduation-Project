import 'package:flutter/material.dart';
import 'package:grad_proj/features/shops/models/Tag.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';

class WrapText extends StatefulWidget {
  const WrapText({super.key, required this.elementsList});
  final List<Tag> elementsList;

  @override
  State<WrapText> createState() => _WrapTextState();
}

class _WrapTextState extends State<WrapText> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.elementsList.map((tag) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(16, 0, 0, 8), // Adjust this for spacing
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5), // Adjust this for chip size
            decoration: BoxDecoration(
              border: Border.all(color: Palette.searchInputBorder, width: 1),
              color: Palette.otpInputBackground, // Customize the chip color
              borderRadius:
                  BorderRadius.circular(30.0), // Adjust this for chip shape
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.elementsList.remove(tag);
                    });
                  },
                  child: const Icon(Icons.clear,
                      size: 20, color: Palette.black), //
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(tag.arabicName, style: TextStyleUtil.tagWordsTextStyle),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
