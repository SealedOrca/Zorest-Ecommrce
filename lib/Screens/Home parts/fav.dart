import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam1/Screens/Cartsection/fav_model.dart';
import 'package:fam1/Screens/products/product_viewpage.dart';
import 'package:flutter/material.dart';
import 'package:fam1/controller/controller.dart'; // Import your DatabaseController

class FavScreen extends StatefulWidget {
  final String userId;

  const FavScreen({
    super.key,
    required this.userId,
  });

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List<FavoriteItem> favoriteItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteItems();
  }

  Future<void> _fetchFavoriteItems() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Fetch favorited items for the current user
      List<FavoriteItem> items = await DatabaseController().getFavoriteItems(widget.userId);
      setState(() {
        favoriteItems = items;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error fetching favorite items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : favoriteItems.isEmpty
              ? const Center(
                  child: Text(
                    'No favorite items found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    FavoriteItem item = favoriteItems[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: GestureDetector(
                        onTap: () async {
  try {
    // Fetch product data from Firestore
    Map<String, dynamic> productData = await DatabaseController().getProductData(item.productId);
    // Navigate to the product view page with the fetched product data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductViewPage(productData: productData, userId: widget.userId),
      ),
    );
  } catch (e) {
    print('Error fetching product data: $e');
    // Handle error if necessary
  }
},

                        child: ListTile(
                          title: Text(
                            item.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Added on : ${_formatTimestamp(item.timestamp)}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          leading: Image.network(
                            item.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite),
                            onPressed: () {
                              // Implement unfavorite functionality
                              _removeFromFavorites(item.productId);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> _removeFromFavorites(String productId) async {
    try {
      await DatabaseController().removeFromFavorites(widget.userId, productId);
      // Remove the item from the local list
      setState(() {
        favoriteItems.removeWhere((item) => item.productId == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );
    } catch (e) {
      print('Error removing item from favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove from favorites')),
      );
    }
  }
}
