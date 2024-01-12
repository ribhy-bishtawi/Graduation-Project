import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grad_proj/theme/text_style_util.dart';

import '../theme/palette.dart';

class CustomTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final Color? focusColor;
  final IconData? icon;
  final String? Function(String?)? validator;
  final String? hintText;
  final bool isIconNeeded;
  final bool isNumerical;
  final TextEditingController textFieldController;
  final TextStyle? textStyle;
  final bool changeColorOnUnfocused;
  final bool isSmallCircularBorder;

  final int maxLines;
  // todo add error state and error message to textfield
  const CustomTextField(
      {super.key,
      this.onChanged,
      this.fillColor = Palette.textInputBackground,
      this.focusColor = Palette.whiteColor,
      required this.textFieldController,
      this.icon,
      this.hintText,
      this.textStyle,
      this.isNumerical = false,
      this.isIconNeeded = false,
      this.validator,
      this.changeColorOnUnfocused = false,
      this.maxLines = 1,
      this.isSmallCircularBorder = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _myFocusNode;
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _myFocusNode.removeListener(_onFocusChange);
    _myFocusNode.dispose();
    _myFocusNotifier.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _myFocusNotifier,
      builder: (_, isFocus, child) {
        return TextFormField(
          inputFormatters: [
            if (widget.isSmallCircularBorder)
              LengthLimitingTextInputFormatter(200)
          ],
          maxLines: widget.maxLines,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.textFieldController,
          textAlignVertical: TextAlignVertical.center,
          style: widget.textStyle,
          keyboardType:
              widget.isNumerical ? TextInputType.number : TextInputType.text,
          focusNode: _myFocusNode,
          decoration: InputDecoration(
              errorStyle: TextStyleUtil.errorTextStyle,
              prefixIcon: widget.isIconNeeded
                  ? Icon(widget.icon, color: Palette.textFieldIcon, size: 20.w)
                  : null,
              errorBorder: TextStyleUtil.errorTextFieldStyle(
                  widget.isSmallCircularBorder),
              focusedErrorBorder: TextStyleUtil.errorTextFieldStyle(
                  widget.isSmallCircularBorder),
              enabledBorder: TextStyleUtil.enabledTextFieldBorder(
                  widget.textFieldController.text.isNotEmpty,
                  widget.isSmallCircularBorder),
              focusedBorder:
                  TextStyleUtil.focusedBorder(widget.isSmallCircularBorder),
              filled: true,
              fillColor: isFocus ||
                      (widget.textFieldController.text.isNotEmpty &&
                          widget.changeColorOnUnfocused)
                  ? widget.focusColor
                  : widget.fillColor,
              hintText: widget.hintText,
              hintStyle: TextStyleUtil.hintTextStyle),
          onChanged: (value) => {widget.onChanged?.call(value)},
        );
      },
    );
  }
}
