// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class InvoicePage extends StatelessWidget {
//   final String invoiceId;

//   const InvoicePage(this.invoiceId);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invoice Details'),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('invoices').doc(invoiceId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(
//               child: Text('Invoice not found.'),
//             );
//           }

//           Map<String, dynamic> invoiceData = snapshot.data!.data() as Map<String, dynamic>;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Invoice ID: $invoiceId'),
//                 const SizedBox(height: 16.0),
//                 Text('Product Name: ${invoiceData['productName']}'),
//                 const SizedBox(height: 8.0),
//                 Text('Quantity: ${invoiceData['quantity']}'),
//                 const SizedBox(height: 8.0),
//                 Text('Price: \$${invoiceData['price']}'),
//                 const SizedBox(height: 8.0),
//                 Text('Total Price: \$${invoiceData['totalPrice']}'),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Navigate back to the previous screen
//                   },
//                   child: const Text('Back'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoicePage extends StatelessWidget {
  final String invoiceId;

  const InvoicePage(this.invoiceId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('invoices').doc(invoiceId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Invoice not found.'),
            );
          }

          Map<String, dynamic> invoiceData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice ID: $invoiceId'),
                const SizedBox(height: 16.0),
                Text('Product Name: ${invoiceData['productName']}'),
                const SizedBox(height: 8.0),
                Text('Quantity: ${invoiceData['quantity']}'),
                const SizedBox(height: 8.0),
                Text('Price: \$${invoiceData['price']}'),
                const SizedBox(height: 8.0),
                Text('Total Price: \$${invoiceData['totalPrice']}'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Navigate back to the previous screen
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


