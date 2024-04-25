import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam1/Screens/products/product_viewpage.dart'; // Import the product view page

class SearchPage extends StatefulWidget {
  final String userId; // Add userId as a parameter

  const SearchPage({super.key, required this.userId});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchItems(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  void _searchItems(String query) {
    FirebaseFirestore.instance
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _searchResults = querySnapshot.docs;
      });
    });
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> productData = _searchResults[index].data() as Map<String, dynamic>;
          String imageUrl = productData['imageUrl'] ?? ''; // Get the product image URL
          String productName = productData['name'] ?? ''; // Get the product name

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: imageUrl.isNotEmpty // Check if the image URL is not empty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl), // Load product image from URL
                    )
                  : const SizedBox(), // If no image URL is provided, display an empty SizedBox
              title: Text(productName),
              subtitle: Text(productData['description'] ?? ''), // Display product description
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductViewPage(productData: productData, userId: widget.userId), // Use widget.userId here
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}
