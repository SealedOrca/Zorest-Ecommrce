import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Updated: [Date]',
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Welcome to [Your Plant E-Commerce App]!',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              const Text(
                '1. Information We Collect',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              _buildParagraph(
                '1.1 Personal Information: We collect the following personal information to provide you with a seamless shopping experience:',
              ),
              _buildBulletPoint('- Name: To personalize your interactions.'),
              _buildBulletPoint(
                  '- Email Address: For order updates and promotions.'),
              _buildBulletPoint('- Address: To deliver your orders.'),
              const SizedBox(height: 10.0),
              _buildParagraph(
                '1.2 Non-Personal Information: We also collect non-personal information, including:',
              ),
              _buildBulletPoint(
                  '- Device Information: Type, model, and operating system.'),
              _buildBulletPoint(
                  '- Usage Information: Pages visited, interactions, and preferences.'),
              const SizedBox(height: 20.0),
              const Text(
                '2. How We Use Your Information',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              _buildParagraph('We use your information for:'),
              _buildBulletPoint(
                  '- Order Processing: To fulfill and deliver your orders.'),
              _buildBulletPoint(
                  '- Communication: Sending updates, newsletters, and promotions.'),
              _buildBulletPoint(
                  '- Improvements: Analyzing data to enhance our app and services.'),
              const SizedBox(height: 20.0),
              // Include the rest of the Privacy Policy content here
              // ...
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10.0),
        const Text('•', style: TextStyle(fontSize: 14.0)),
        const SizedBox(width: 5.0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: PrivacyPolicyPage(),
    ),
  );
}
