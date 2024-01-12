import 'package:flutter/material.dart';

import '../theme/palette.dart';

class GenderCheckbox extends StatefulWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool> onChecked;

  const GenderCheckbox({
    super.key,
    required this.text,
    required this.isChecked,
    required this.onChecked,
  });

  @override
  _GenderCheckboxState createState() => _GenderCheckboxState();
}

class _GenderCheckboxState extends State<GenderCheckbox> {
  TextStyle regularTextStyle = const TextStyle(
    fontSize: 16,
    color: Palette.textInputText,
    fontWeight: FontWeight.w400,
    fontFamily: "Almarai",
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => widget.onChecked(widget.isChecked ? false : true),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              // todo: make border dynamic
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: widget.isChecked
                    ? Colors.white
                    : Palette.genderUnselectedBorder,
              ),
              color: widget.isChecked
                  ? Palette.secondaryButtonBackground
                  : Colors.white,
            ),
            child: Row(
              children: [
                Checkbox(
                  side: const BorderSide(
                    width: 1,
                    color: Palette.genderUnselectedBorder,
                  ),
                  checkColor: Colors.white,
                  activeColor: Palette.primary,
                  shape: const CircleBorder(),
                  value: widget.isChecked,
                  onChanged: (value) => {widget.onChecked(value!)},
                ),
                Text(
                  widget.text,
                  style: regularTextStyle,
                ),
              ],
            ),
          )),
    );
  }
}
