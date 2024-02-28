import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.radioText,
    required this.radioActiveColor,
    required this.radioInactiveColor,
    required this.isRadioSelected,
    required this.onTapRadio,
    required this.textColor,
  });

  final Color radioActiveColor;
  final Color textColor;
  final Color radioInactiveColor;
  final bool isRadioSelected;
  final String radioText;
  final void Function() onTapRadio;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapRadio,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isRadioSelected ? radioActiveColor : radioInactiveColor,
            border: Border.all(color: radioActiveColor, width: 1)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(
            radioText,
            style: TextStyle(
              color: isRadioSelected ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
