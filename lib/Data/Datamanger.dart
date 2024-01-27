// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:uuid/uuid.dart';

// class DataManager {
//   static final DataManager _instance = DataManager._internal();

//   factory DataManager() {
//     return _instance;
//   }

//   DataManager._internal();

//   // Initialize Firebase
//   Future<void> init() async {
//     await Firebase.initializeApp();
//   }

//   // Insert a product into Firestore
//   Future<void> insertProduct(Product product, String imagePath) async {
//     // Generate a unique identifier using UUID
//     product.id = Uuid().v4();

//     await FirebaseFirestore.instance.collection('products').doc(product.id).set(product.toMap());

//     if (imagePath.isNotEmpty) {
//       String imageUrl = await uploadImageToStorage(imagePath);
//       product.imageUrl = imageUrl;
//       await FirebaseFirestore.instance.collection('products').doc(product.id).update({
//         'imageUrl': imageUrl,
//       });
//     }
//   }

//   // Delete a product from Firestore
//   Future<void> deleteProduct(String? productId, String? imageUrl) async {
//     await FirebaseFirestore.instance.collection('products').doc(productId).delete();

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       await deleteImageFromStorage(imageUrl);
//     }
//   }

//   // Get a list of products from Firestore
//   Future<List<Product>> getProducts() async {
//     QuerySnapshot<Map<String, dynamic>> querySnapshot =
//         await FirebaseFirestore.instance.collection('products').get();

//     return querySnapshot.docs.map((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       return Product(
//         id: doc.id,
//         name: data['name'],
//         price: data['price'],
//         imageUrl: data['imageUrl'],
//       );
//     }).toList();
//   }

//   // Upload a product to Firestore
//   Future<void> uploadProductToFirestore(Product product) async {
//     await FirebaseFirestore.instance.collection('products').doc(product.id).set(product.toMap());
//   }

//   // Delete a product from Firestore
//   Future<void> deleteProductFromFirestore(String? productId) async {
//     await FirebaseFirestore.instance.collection('products').doc(productId).delete();
//   }

//   // Upload an image to Firebase Storage
//   Future<String> uploadImageToStorage(String imagePath) async {
//     Reference storageReference = FirebaseStorage.instance.ref().child('images/${Uuid().v4()}');
//     UploadTask uploadTask = storageReference.putFile(File(imagePath));
//     await uploadTask.whenComplete(() => null);

//     return await storageReference.getDownloadURL();
//   }

//   // Delete an image from Firebase Storage
//   Future<void> deleteImageFromStorage(String imageUrl) async {
//     await FirebaseStorage.instance.refFromURL(imageUrl).delete();
//   }
// }

// class Product {
//   String? id;
//   final String name;
//   final double price;
//   String? imageUrl;

//   Product({
//     this.id,
//     required this.name,
//     required this.price,
//     this.imageUrl,
//   });

//   // Convert the product to a map for Firestore operations
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'imageUrl': imageUrl,
//     };
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam1/Screens/Cart/cart.dart';
import 'package:fam1/Screens/Cart/paymentmethod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal();

  // Initialize Firebase
  Future<void> init() async {
    // Check if the platform is web before calling enablePersistence
    if (kIsWeb) {
      await FirebaseFirestore.instance.enablePersistence();
    }
  }

  Future<void> insertProduct(Product product, String imagePath) async {
    product.id = Uuid().v4();
    await FirebaseFirestore.instance.collection('products').doc(product.id).set(product.toMap());

    if (imagePath.isNotEmpty) {
      String imageUrl = await uploadImageToStorage(product.id!, imagePath);
      product.imageUrl = imageUrl;
      await FirebaseFirestore.instance.collection('products').doc(product.id).update({
        'imageUrl': imageUrl,
      });
    }
  }

  Future<void> deleteProduct(String? productId, String? imageUrl) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      await deleteImageFromStorage(imageUrl);
    }
  }

  Future<List<Product>> getProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Product(
        id: doc.id,
        name: data['name'],
        price: data['price'],
        imageUrl: data['imageUrl'],
      );
    }).toList();
  }

  Future<void> uploadProductToFirestore(Product product) async {
    await FirebaseFirestore.instance.collection('products').doc(product.id).set(product.toMap());
  }

  Future<void> deleteProductFromFirestore(String? productId) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
  }

  Future<String> uploadImageToStorage(String productId, String imagePath) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('images/$productId');
    UploadTask uploadTask = storageReference.putFile(File(imagePath));
    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

  Future<void> deleteImageFromStorage(String imageUrl) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }
}

class CartController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxList<Map<String, dynamic>> cart = <Map<String, dynamic>>[].obs;
  VoidCallback? onCartChanged;

  Future<void> addToCart(dynamic product, int quantity) async {
    var buyerId = _auth.currentUser?.uid;
    var sellerId = (product is Product) ? product.id : '';

    if (buyerId != null && sellerId != null) {
      Map<String, dynamic> cartItem = {
        'productId': (product is Product) ? product.id : '',
        'productName': (product is Product) ? product.name : '',
        'quantity': quantity,
        'price': (product is Product) ? product.price : 0,
        'imageURL': (product is Product) ? product.imageUrl : '',
      };

      await FirebaseFirestore.instance.collection('shoppingcart').add({
        'buyerId': buyerId,
        'sellerId': sellerId,
        'cartItem': cartItem,
        'timestamp': FieldValue.serverTimestamp(),
      });

      cart.add(cartItem);

      if (onCartChanged != null) {
        onCartChanged!();
      }
    }
  }


  Future<void> removeFromCart(Map<String, dynamic> cartItem) async {
    cart.remove(cartItem);

    if (onCartChanged != null) {
      onCartChanged!();
    }

    await FirebaseFirestore.instance.collection('shoppingcart').doc(cartItem['id']).delete();
  }

  Future<void> clearCart() async {
    cart.clear();

    if (onCartChanged != null) {
      onCartChanged!();
    }

    QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance.collection('shoppingcart').get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }

  double get totalPrice {
    double total = 0.0;

    for (var item in cart) {
      total += (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
    }

    return total;
  }

  void updateCart() {
    if (onCartChanged != null) {
      onCartChanged!();
    }
  }

  void checkout() {
    Get.to(DummyPaymentPage(
      onPaymentComplete: () {
        clearCart();
      },
    ));
  }

  void _openCart() {
    Get.to(CartPage());
  }
}

class Product {
  String? id;
  final String name;
  final double price;
  String? imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

