import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingFullScreen extends StatelessWidget {
  const LoadingFullScreen({super.key, required this.loadingAnimationText});

  final String loadingAnimationText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/json/ambulance.json',
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
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
      ),
    );
  }
}
