import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({super.key, required this.emptySateMessage});

  final String emptySateMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/json/empty_search.json',
            width: MediaQuery.of(context).size.width * 0.75,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              emptySateMessage,
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
