import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.loadingAnimationText});

  final String loadingAnimationText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Row(
        children: [
          Lottie.asset(
            'assets/json/ambulance.json',
            width: MediaQuery.of(context).size.width * 0.35,
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Text(
              loadingAnimationText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
                height: 1.5,
                color: Color.fromARGB(255, 103, 100, 100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
