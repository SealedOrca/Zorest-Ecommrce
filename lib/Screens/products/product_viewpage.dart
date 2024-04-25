
import 'package:fam1/Screens/Cartsection/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:fam1/controller/controller.dart'; // Import your DatabaseController
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductViewPage extends StatefulWidget {
  final Map<String, dynamic> productData;
  final String userId; // Add user ID as a parameter

  const ProductViewPage({super.key, required this.productData, required this.userId});

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  final int _quantity = 1;
  final List<String> _reviews = []; // List to store reviews

  @override
  Widget build(BuildContext context) {
    final String sellerId = widget.productData['seller_id'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color:  Color.fromARGB(255, 86, 150, 107),), // Back button color
        elevation: 0, // Remove app bar elevation
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart), // Cart icon
            onPressed: () {
              // Navigate to the cart page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(userId: widget.userId, productData: widget.productData),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Call method to add to favorites
              _addToFavorites(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.productData['imageUrls']?.isNotEmpty ?? false ? widget.productData['imageUrls'][0] : ''), // Check if imageUrls is not empty
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 86, 150, 107).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    
                  ),
                ),
              ],
            ),
            Divider(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product details UI
                  Text(
                    'Price: \Rs${widget.productData['price']?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                 
                  const SizedBox(height: 6),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.productData['description'] ?? 'No description available',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                 
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category: ${widget.productData['category'] ?? 'Unknown'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),

                      Text(
                        'Available: ${widget.productData['available'] ?? false}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 6),
                 Row(
  children: [
    RatingBar.builder(
      initialRating: widget.productData['rating']?.toDouble() ?? 0,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 30,
      itemBuilder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Icon(
          Icons.star,
          color: Colors.amber.withOpacity(0.8),
        ),
      ),
      onRatingUpdate: (rating) {
        // Handle rating update
      },
    ),
    SizedBox(width: 10), // Add some spacing between the rating bar and text
    Text(
      'Rate the product: ${widget.productData['rating']?.toStringAsFixed(1) ?? "N/A"}',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
Divider(),
                  const SizedBox(height: 24),
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          _reviews[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (comment) {
                            setState(() {
                              _reviews.add(comment);
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle comment submission
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color:  Color.fromARGB(255, 86, 150, 107),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle add to cart button press
              addToCart();
            },
            icon: const Icon(Icons.shopping_cart), // Cart icon
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor:  Color.fromARGB(255, 249, 252, 250),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to add the current item to favorites
  void _addToFavorites(BuildContext context) async {
    try {
      // Call the addToFavorites method from your DatabaseController
      await DatabaseController().addToFavorites(
        userId: widget.userId,
        productId: widget.productData['productId'],
        productName: widget.productData['name'],
        price: widget.productData['price'],
        imageUrl: widget.productData['imageUrls']?.isNotEmpty ?? false ? widget.productData['imageUrls'][0] : '',
      );

      // Provide feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle errors
      print('Error adding product to favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add product to favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Method to add the product to the cart
  void addToCart() {
    // Construct the cart item object
    Map<String, dynamic> cartItem = {
      'productId': widget.productData['productId'], // Use productId instead of id
      'productName': widget.productData['name'],
      'quantity': _quantity,
      'imageUrl': widget.productData['imageUrls']?.isNotEmpty ?? false ? widget.productData['imageUrls'][0] : null, // Use the first image URL if available
      // Add any other necessary data
    };

    // Call the method to add the item to the cart
    DatabaseController().addToCart(
      productId: widget.productData['productId'],
      productName: widget.productData['name'],
      price: widget.productData['price'],
      quantity: _quantity,
      userId: widget.userId,
      sellerId: widget.productData['seller_id'],
      imageUrl: widget.productData['imageUrls']?.isNotEmpty ?? false ? widget.productData['imageUrls'][0] : null, // Pass the first image URL if available
    );

    // You can then pass this cart item to your cart controller or perform any other actions
    // For now, let's print the cart item data
    print('Added to cart: $cartItem');
  }
}
