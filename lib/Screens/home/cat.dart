import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProductsPage extends StatelessWidget {
  final String? category;

  CategoryProductsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category ?? "Unknown"} Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> productData =
                  documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(productData['name'] ?? 'Unknown Product'),
                subtitle: Text('Price: \$${productData['price'] ?? 0.0}'),
                leading: Image.network(
                  productData['imageUrl'] ??
                      'https://via.placeholder.com/150', // Placeholder image if imageUrl is not available
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                // Add more details or customization based on your product structure
              );
            },
          );
        },
      ),
    );
  }
}
