import 'package:flutter/material.dart';
import 'package:fam1/controller/controller.dart'; // Import your controller class

class BoughtItemsAndReceiptsPage extends StatelessWidget {
  const BoughtItemsAndReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bought Items & Receipts'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bought Items'),
              Tab(text: 'Bought Receipts'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BoughtItemsPage(),
            BoughtReceiptsPage(),
          ],
        ),
      ),
    );
  }
}

class BoughtItemsPage extends StatelessWidget {
  const BoughtItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseController().getBoughtItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> boughtItems = snapshot.data ?? [];
          if (boughtItems.isEmpty) {
            return const Center(child: Text('No bought items found.'));
          } else {
            // Build UI for displaying bought items
            return ListView.builder(
              itemCount: boughtItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = boughtItems[index];
                // Build UI for each bought item
                return ListTile(
                  title: Text(item['productName']),
                  subtitle: Text('Price: ${item['price']}'),
                  // Add more details as needed
                );
              },
            );
          }
        }
      },
    );
  }
}

class BoughtReceiptsPage extends StatelessWidget {
  const BoughtReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseController().getBoughtReceipts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> boughtReceipts = snapshot.data ?? [];
          if (boughtReceipts.isEmpty) {
            return const Center(child: Text('No bought receipts found.'));
          } else {
            // Build UI for displaying bought receipts
            return ListView.builder(
              itemCount: boughtReceipts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> receipt = boughtReceipts[index];
                // Build UI for each bought receipt
                return ListTile(
                  title: Text('Receipt ID: ${receipt['receiptId']}'),
                  subtitle: Text('Total Price: ${receipt['totalPrice']}'),
                  // Add more details as needed
                );
              },
            );
          }
        }
      },
    );
  }
}
