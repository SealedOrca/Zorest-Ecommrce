import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String sellerId; // Seller ID
  final String buyerId; // Buyer ID
  final String imageUrl; // Image URL

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.sellerId,
    required this.buyerId,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'imageUrl': imageUrl, // Include imageUrl in JSON serialization
    };
  }

  factory CartItem.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: data['productId'],
      productName: data['productName'],
      price: data['price'],
      quantity: data['quantity'],
      sellerId: data['sellerId'],
      buyerId: data['buyerId'],
      imageUrl: data['imageUrl'], // Initialize imageUrl when deserializing
    );
  }
}
