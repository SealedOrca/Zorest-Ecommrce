import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItem {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  final Timestamp timestamp;

  FavoriteItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
