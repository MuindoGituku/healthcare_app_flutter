import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              "assets/images/arrow_back.svg",
              width: 20,
              height: 20,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
