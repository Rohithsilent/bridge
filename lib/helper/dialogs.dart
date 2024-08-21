import 'package:flutter/material.dart';


class dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            msg,
            style: const TextStyle(
              color: Colors.black87, // Text color
              fontSize: 16.0,        // Font size
              fontWeight: FontWeight.bold, // Font weight
            ),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.9), // Background color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Set color to blue
        ),
      ),
    );
  }

}
