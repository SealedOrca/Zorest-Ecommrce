import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Product Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason for Reporting'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reason for reporting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitReport();
                  }
                },
                child: const Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReport() async {
    // Ensure Firebase is initialized
    await Firebase.initializeApp();

    // Upload report details to Firebase
    String name = _nameController.text;
    String description = _descriptionController.text;
    String reason = _reasonController.text;

    try {
      // Upload report to Firestore
      await FirebaseFirestore.instance.collection('reports').add({
        'name': name,
        'description': description,
        'reason': reason,
      });

      // Report submitted successfully, you can show a success message or navigate back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Report submitted successfully'),
      ));
      // Clear form fields
      _nameController.clear();
      _descriptionController.clear();
      _reasonController.clear();
    } catch (error) {
      // Handle error if report submission fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit report: $error'),
      ));
    }
  }
}
