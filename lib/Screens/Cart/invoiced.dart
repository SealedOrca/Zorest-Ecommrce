import 'package:fam1/Screens/Cart/invoicepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction History'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sold Items'),
              Tab(text: 'Bought Items'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TransactionList(isSold: true),
            TransactionList(isSold: false),
          ],
        ),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  final bool isSold;

  const TransactionList({Key? key, required this.isSold}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('invoices').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading transactions.'));
        }

        var transactions = snapshot.data!.docs;

        if (transactions.isEmpty) {
          return const Center(child: Text('No transactions available.'));
        }

        var filteredTransactions = transactions.where((transaction) {
          final transactionData = transaction.data() as Map<String, dynamic>;
          return (isSold
                  ? transactionData['sellerId']
                  : transactionData['buyerId']) ==
              FirebaseAuth.instance.currentUser?.uid;
        }).toList();

        return ListView.builder(
          itemCount: filteredTransactions.length,
          itemBuilder: (context, index) {
            final transaction =
                filteredTransactions[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text('Transaction ID: ${filteredTransactions[index].id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isSold
                      ? 'Buyer ID: ${transaction['buyerId']}'
                      : 'Seller ID: ${transaction['sellerId']}'),
                  Text('Total Price: \$${transaction['totalPrice']}'),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the detailed view of the transaction
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InvoicePage(filteredTransactions[index].id),
                        ),
                      );
                    },
                    child: const Text('View Details'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
