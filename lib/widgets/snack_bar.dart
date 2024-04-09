import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showFeedbackSnack(
    BuildContext context, String snackMessage, Color snackColor) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        snackMessage,
      ),
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: snackColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 5),
    ),
  );
}
