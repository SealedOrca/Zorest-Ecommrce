import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fam1/controller/controller.dart'; // Import your controller class

class SoldItemsPage extends StatelessWidget {
  final DatabaseController _dbController = DatabaseController();

  SoldItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserID = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold Items and Receipts'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbController.getSoldReceipts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching sold receipts: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> soldReceipts = snapshot.data ?? [];
            if (soldReceipts.isEmpty) {
              return const Center(child: Text('No sold receipts found.'));
            } else {
              return ListView.builder(
                itemCount: soldReceipts.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> receipt = soldReceipts[index];
                  return ExpansionTile(
                    title: const Text('Receipt'),
                    subtitle: Text('Total Price: ${receipt['totalPrice'] ?? 'N/A'}'),
                    children: [
                      ListTile(
                        title: Text('Buyer ID: ${receipt['buyerId'] ?? 'N/A'}'),
                      ),
                      ListTile(
                        title: Text('Card Number: ${receipt['cardNumber'] ?? 'N/A'}'),
                      ),
                      ListTile(
                        title: Text('Street: ${receipt['street'] ?? 'N/A'}'),
                      ),
                      ListTile(
                        title: Text('City: ${receipt['city'] ?? 'N/A'}'),
                      ),
                      ListTile(
                        title: Text('State: ${receipt['state'] ?? 'N/A'}'),
                      ),
                      ListTile(
                        title: Text('Postal Code: ${receipt['postalCode'] ?? 'N/A'}'),
                      ),
                      ListTile(
                        title: Text('Date of Sale: ${receipt['timestamp'] != null ? (receipt['timestamp'] as Timestamp).toDate().toString() : 'N/A'}'),
                      ),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _dbController.getSoldItems(userId: currentUserID ?? '',),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error fetching sold items: ${snapshot.error}'));
                          } else {
                            List<Map<String, dynamic>> soldItems = snapshot.data ?? [];
                            if (soldItems.isEmpty) {
                              return const Center(child: Text('No sold items found for this receipt.'));
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: soldItems.map((soldItem) {
                                  return ListTile(
                                    title: Text('Product ID: ${soldItem['productId'] ?? 'N/A'}'),
                                    subtitle: Text('Buyer: ${soldItem['buyerId'] ?? 'N/A'}'),
                                    // Add more sold item details as needed
                                  );
                                }).toList(),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
