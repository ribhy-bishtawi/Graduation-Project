import 'package:flutter/cupertino.dart';
import 'package:grad_proj/resources/app_strings.dart';

import 'CustomRadioButton.dart';

enum Gender { male, female }

class GenderSelector extends StatefulWidget {
  final ValueChanged<Gender?> onGenderChange;
  final bool isCheckedMale;
  final bool isCheckedFemale;

  const GenderSelector(
      {super.key,
      required this.onGenderChange,
      required this.isCheckedMale,
      required this.isCheckedFemale});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  bool isChecked = false;
  bool? isCheckedMale;
  bool? isCheckedFemale;
  bool _hasGender = false;
  Gender? _gender;

  @override
  void initState() {
    super.initState();
    isCheckedMale = widget.isCheckedMale;
    isCheckedFemale = widget.isCheckedFemale;
  }

  void onGenderChange() {
    setState(() {
      _hasGender = isCheckedFemale! || isCheckedMale!;
      if (isCheckedMale!) {
        _gender = Gender.male;
      } else if (isCheckedFemale!) {
        _gender = Gender.female;
      } else {
        _gender = null;
      }
      widget.onGenderChange(_gender);
    });
  }

  void handleFemaleCheckboxChange(bool value) {
    setState(() {
      isCheckedFemale = value;
      /* this if statement is used to unselect a gender
        * if removed, clicking on one button would trigger the
        * other checkbox which is unwanted behavior */
      if (isCheckedMale!) {
        isCheckedMale = !value;
      }
      onGenderChange();
    });
  }

  void handleMaleCheckboxChange(bool value) {
    setState(() {
      isCheckedMale = value;
      if (isCheckedFemale!) {
        isCheckedFemale = !value;
      }
      onGenderChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GenderCheckbox(
          text: AppStrings.male,
          isChecked: isCheckedMale!,
          onChecked: (value) {
            handleMaleCheckboxChange(value);
          },
        ),
        const SizedBox(
          width: 10,
        ),
        GenderCheckbox(
          text: AppStrings.female,
          isChecked: isCheckedFemale!,
          onChecked: (value) {
            handleFemaleCheckboxChange(value);
          },
        ),
      ],
    );
  }
}
