import 'package:flutter/material.dart';
import 'dart:async';
import 'package:qt_qt/screens/transaction_success_screen.dart'; // Add this import

class TransactionProcessingScreen extends StatefulWidget {
  const TransactionProcessingScreen({Key? key}) : super(key: key);

  @override
  State<TransactionProcessingScreen> createState() => _TransactionProcessingScreenState();
}

class _TransactionProcessingScreenState extends State<TransactionProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate processing time and then navigate to success/failure
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TransactionSuccessScreen(), // Make sure this class exists
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Processing Animation
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade300),
                strokeWidth: 6,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Processing Transaction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}