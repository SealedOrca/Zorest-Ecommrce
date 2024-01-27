import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to [Your Plant E-Commerce App]!',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'About Our App',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              _buildParagraph(
                'At [Your Plant E-Commerce App], we are passionate about bringing nature into your life. Our app is designed to provide you with a delightful and convenient way to explore, choose, and purchase a variety of beautiful plants for your home or workspace.',
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Our Mission',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              _buildParagraph(
                'Our mission is to enhance the well-being of our customers by making it easy for them to surround themselves with the beauty of nature. We strive to offer a diverse selection of high-quality plants, along with a seamless shopping experience and excellent customer service.',
              ),
              const SizedBox(height: 20.0),
              // Include additional sections about your team, values, or any other relevant information
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
}

void main() {
  runApp(
    MaterialApp(
      home: AboutPage(),
    ),
  );
}
