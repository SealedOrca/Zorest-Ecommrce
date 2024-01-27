import 'package:flutter/material.dart';

class DummyPaymentPage extends StatelessWidget {
  final Function() onPaymentComplete;

  const DummyPaymentPage({Key? key, required this.onPaymentComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Payment Details'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate payment processing
                // You can add real payment logic here
                // For simplicity, we'll just delay for 2 seconds
                Future.delayed(const Duration(seconds: 2), () {
                  onPaymentComplete();
                  Navigator.of(context).pop(); // Navigate back after payment
                });
              },
              child: const Text('Process Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
