import 'dart:io';
import 'package:fam1/Screens/Cartsection/fav_model.dart';
import 'package:fam1/controller/cartcontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserToken() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return await user.getIdToken();
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user token: $e');
      }
      rethrow;
    }
  }

  Future<void> updateUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  Future<void> clearUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
      await clearUserToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out user: $e');
      }
      rethrow;
    }
  }
  


  Future<List<DocumentSnapshot>> editAndGetUserProducts(
      String productId, Map<String, dynamic> updatedProductData, String userId) async {
    try {
      await _firestore.collection('products').doc(productId).update(updatedProductData);

      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('seller_id', isEqualTo: userId)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print('Error editing product and getting user products: $e');
      }
      rethrow;
    }
  }

  

  Future<void> updateProduct(String productId, Map<String, dynamic> newData) async {
    try {
      await _firestore.collection('products').doc(productId).update(newData);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating product: $e');
      }
      rethrow;
    }
  }



  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting all products: $e');
      return [];
    }
  }



  Future<QuerySnapshot> searchProducts(String query) async {
    try {
      return await _firestore.collection('products').where('name', isEqualTo: query).get();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching products: $e');
      }
      rethrow;
    }
  }

   Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user: $e');
      }
      return null;
    }
  }


  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
        return userData;
      } else {
        if (kDebugMode) {
          print('User data not found for user ID: $userId');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      rethrow;
    }
  }


  Future<void> editUserData(String userId, Map<String, dynamic> updatedUserData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedUserData);
      if (kDebugMode) {
        print('User data updated successfully for user ID: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error editing user data: $e');
      }
      rethrow;
    }
  }



  Future<String> uploadProfileImage(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }

      String fileName = '${user.uid}_profile_image';

      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images/$fileName');
      await ref.putFile(imageFile);

      String imageUrl = await ref.getDownloadURL();

      await _firestore.collection('users').doc(user.uid).update({'profileImageUrl': imageUrl});

      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
      rethrow;
    }
  }
  



  Future<void> increaseQuantity(String cartItemId) async {
    try {
      await _firestore.collection('cart').doc(cartItemId).update({
        'quantity': FieldValue.increment(1),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error increasing quantity: $e');
      }
      rethrow;
    }
  }

  Future<void> decreaseQuantity(String cartItemId) async {
    try {
      await _firestore.collection('cart').doc(cartItemId).update({
        'quantity': FieldValue.increment(-1),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error decreasing quantity: $e');
      }
      rethrow;
    }
  }
  



  

 Future<void> uploadProduct({
  required String name,
  required String description,
  required double price,
  required String category,
  required List<File> imageFiles,
  required List<Map<String, dynamic>> reviews,
  required Map<String, dynamic> attributes,
  required bool available,
  required Map<String, dynamic> shippingInfo,
  required bool favorite,
  required int amount, // New parameter for the amount of product
}) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated.');
    }

    String productId = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}';
    List<String> imageUrls = await _uploadProductImages(productId, imageFiles);

    await _firestore.collection('products').doc(productId).set({
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrls': imageUrls,
      'reviews': reviews,
      'available': available,
      'shipping_info': shippingInfo,
      'seller_id': user.uid,
      'favorite': favorite,
      'amount': amount, // Add amount to the document
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error uploading product: $e');
    }
    rethrow;
  }
}

Future<void> addToFavorites({
  required String userId,
  required String productId,
  required String productName,
  required double price,
  required String imageUrl,
}) async {
  try {
    // Add product to user's favorites collection
    await _firestore.collection('users').doc(userId).collection('favorites').doc(productId).set({
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update the 'favorite' field in the original product document
    await _firestore.collection('products').doc(productId).update({
      'favorite': true,
    });
  } catch (e) {
    print('Error adding to favorites: $e');
    rethrow;
  }
}


  Future<List<String>> _uploadProductImages(String productId, List<File> imageFiles) async {
    try {
      List<String> imageUrls = [];

      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final fileName = 'product_$productId-$i';
        final uploadTask = await firebase_storage.FirebaseStorage.instance
            .ref('product_images/$fileName')
            .putFile(file);

        final imageUrl = await uploadTask.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading product images: $e');
      }
      rethrow;
    }
  }

  Future<List<FavoriteItem>> getFavoriteItems(String userId) async {
  try {
    QuerySnapshot snapshot =
        await _firestore.collection('users').doc(userId).collection('favorites').get();
    List<FavoriteItem> favoriteItems = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Timestamp timestamp = data['timestamp']; // Retrieve timestamp from Firestore
      return FavoriteItem(
        productId: data['productId'],
        productName: data['productName'],
        price: data['price'],
        imageUrl: data['imageUrl'],
        timestamp: timestamp, // Include timestamp in FavoriteItem constructor
      );
    }).toList();
    return favoriteItems;
  } catch (e) {
    print('Error fetching favorite items: $e');
    rethrow;
  }
}

Future<void> removeFromFavorites(String userId, String productId) async {
  try {
    // Remove the product from the user's favorites collection
    await _firestore.collection('users').doc(userId).collection('favorites').doc(productId).delete();

    // Update the 'favorite' field in the original product document
    await _firestore.collection('products').doc(productId).update({
      'favorite': false,
    });
  } catch (e) {
    print('Error removing from favorites: $e');
    rethrow;
  }
}

// Inside DatabaseController class
Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category) // Filter by category
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } catch (error) {
    print('Error fetching products by category: $error');
    rethrow; // Propagate the error
  }
}

  Future<void> savePaymentMethod(Map<String, dynamic> paymentDetails) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }

      await _firestore.collection('payments').add({
        'name': paymentDetails['name'],
        'accountNumber': paymentDetails['accountNumber'],
        'expiryDate': paymentDetails['expiryDate'],
        'cvv': paymentDetails['cvv'],
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving payment method: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPayments() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<Map<String, dynamic>> payments = [];

      querySnapshot.docs.forEach((doc) {
        payments.add(doc.data());
      });

      return payments;
    } catch (e) {
      print('Error fetching payments: $e');
      rethrow;
    }
  }


Future<List<Map<String, dynamic>>> _fetchProducts(String category) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .get();

    List<Map<String, dynamic>> products = [];
    for (var product in querySnapshot.docs) {
      Map<String, dynamic> productData =
          product.data() as Map<String, dynamic>;
      products.add(productData);
    }

    return products;
  } catch (error) {
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> getBoughtItems() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection('cart')
          .where('buyerId', isEqualTo: user.uid)
          .get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bought items: $e');
      }
      rethrow;
    }
  }

Future<List<Map<String, dynamic>>> getSoldItems({required String userId}) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('receipts').get();
    List<Map<String, dynamic>?> soldReceipts = querySnapshot.docs
        .map((doc) => doc.exists ? doc.data() : null)
        .toList();
    // Remove null elements and cast the list to the correct type
    return soldReceipts.where((data) => data != null).cast<Map<String, dynamic>>().toList();
  } catch (e) {
    print('Error fetching sold receipts: $e');
    rethrow;
  }
}


Future<List<Map<String, dynamic>>> getProductsByUserId(String userId) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('seller_id', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } catch (error) {
    print('Error fetching products by user ID: $error');
    rethrow;
  }
}



  Future<List<Map<String, dynamic>>> getBoughtReceipts() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection('receipts')
          .where('buyerId', isEqualTo: user.uid)
          .get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bought receipts: $e');
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSoldReceipts() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('receipts').get();
    List<Map<String, dynamic>?> soldReceipts = querySnapshot.docs
        .map((doc) => doc.exists ? doc.data() : null)
        .toList();
    // Remove null elements and cast the list to the correct type
    return soldReceipts.where((data) => data != null).cast<Map<String, dynamic>>().toList();
  } catch (e) {
    print('Error fetching sold receipts: $e');
    rethrow;
  }
}

  
   Future<void> addToCart({
  required String productId,
  required String productName,
  required double price,
  required int quantity,
  required String userId, // Buyer ID
  required String sellerId, // Seller ID
  required String imageUrl, // Image URL
}) async {
  try {
    await _firestore.collection('cart').add({
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'sellerId': sellerId, // Store seller ID
      'buyerId': userId, // Store buyer ID
      'imageUrl': imageUrl,
    });
  } catch (e) {
    print('Error adding to cart: $e');
    rethrow;
  }
}


Future<Map<String, dynamic>> getProductData(String productId) async {
    try {
      // Retrieve the product document from Firestore
      DocumentSnapshot productSnapshot = await _firestore.collection('products').doc(productId).get();

      // Check if the document exists
      if (productSnapshot.exists) {
        // Extract the data from the document
        Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;
        return productData;
      } else {
        // Handle if the document does not exist
        throw Exception("Product with ID $productId does not exist");
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching product data: $e");
      throw Exception("Failed to fetch product data");
    }
  }


Future<void> createReceipt({
  required List<CartItem> cartItems,
  required String buyerId,
  required String sellerId,
  required String street,
  required String city,
  required String state,
  required String postalCode,
  required String cardNumber,
  required String expiryDate,
  required String cvv,
}) async {
  try {
    final batch = _firestore.batch();
    final receiptRef = _firestore.collection('receipts').doc(); // Generate new document reference with unique ID

    // Calculate total price
    double totalPrice = cartItems.fold(0, (prev, item) => prev + (item.price * item.quantity));

    // Add receipt details to batch
    batch.set(receiptRef, {
      'receiptId': receiptRef.id, // Assigning receipt ID
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Commit batch operation
    await batch.commit();
  } catch (e) {
    print('Error creating receipt: $e');
    rethrow;
  }
}


  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _firestore.collection('cart').doc(cartItemId).delete();
    } catch (e) {
      print('Error removing item from cart: $e');
      rethrow;
    }
  }

Future<List<CartItem>> getCartItems(String userId) async {
  try {
    QuerySnapshot querySnapshot = await _firestore.collection('cart').where('buyerId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => CartItem.fromDocument(doc)).toList();
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error getting cart items: $e');
      print('Stack trace: $stackTrace');
    }
    rethrow;
  }
}
}


