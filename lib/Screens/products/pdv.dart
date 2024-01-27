// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:fam1/Data/Datamanger.dart';
// import 'package:fam1/Screens/Cart/invoicepage.dart';

// class ProductViewPage extends StatefulWidget {
//   final Product product;

//   const ProductViewPage({
//     Key? key,
//     required this.product, required Map<String, dynamic> productData, required Map<String, dynamic> id,
//   }) : super(key: key);

//   @override
//   _ProductViewPageState createState() => _ProductViewPageState();
// }

// class _ProductViewPageState extends State<ProductViewPage> {
//   int selectedQuantity = 1;
//   late CartController cartController;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize CartController when the widget is created
//     cartController = Get.put(CartController());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 200.0,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 image: DecorationImage(
//                   image: NetworkImage(widget.product.imageUrl ?? ''),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             Text(
//               widget.product.name,
//               style:
//                   const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               'Price: \$${widget.product.price}',
//               style: const TextStyle(fontSize: 18.0),
//             ),
//             const SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Quantity:',
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//                 DropdownButton<int>(
//                   value: selectedQuantity,
//                   items: List.generate(10, (index) => index + 1)
//                       .map((quantity) => DropdownMenuItem<int>(
//                             value: quantity,
//                             child: Text('$quantity'),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedQuantity = value ?? 1;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Add the product to the shopping cart
//                 addToCart(widget.product, selectedQuantity);
//                 // Add the product to the Firestore shopping cart collection
//                 addToFirestoreCart(widget.product, selectedQuantity);
//                 // Create an invoice and navigate to the invoice page
//                 createInvoice(context, widget.product, selectedQuantity);
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.blue, // Change button color here
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(12.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.shopping_cart),
//                     SizedBox(width: 8.0),
//                     Text('Add to Cart & Generate Invoice'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Modify the addToCart method to handle both Product and Map<String, dynamic>
//   void addToCart(dynamic product, int quantity) {
//     if (product is Product) {
//       // If product is of type Product, convert it to Map<String, dynamic>
//       Map<String, dynamic> productData = {
//         'id': product.id,
//         'name': product.name,
//         'price': product.price,
//         'imageUrl': product.imageUrl,
//         // Add other fields as needed
//       };
//       cartController.addToCart(productData as Product, quantity);
//     } else if (product is Map<String, dynamic>) {
//       // If product is already of type Map<String, dynamic>, use it directly
//       cartController.addToCart(product as Product, quantity);
//     }
//   }

//   void addToFirestoreCart(Product product, int quantity) {
//     // Add the product to the Firestore shopping cart collection
//     FirebaseFirestore.instance.collection('shoppingcart').add({
//       'userId': FirebaseAuth.instance.currentUser?.uid ?? '',
//       'productId': product.id,
//       'productName': product.name,
//       'quantity': quantity,
//       'price': product.price,
//       'imageURL': product.imageUrl ?? '',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   void createInvoice(BuildContext context, Product product, int quantity) {
//     // Fetch seller ID from the product data
//     String? sellerId = ''; // You may want to fetch this from your product data

//     // Fetch buyer ID from the currently logged-in user
//     String buyerId = FirebaseAuth.instance.currentUser?.uid ?? '';

//     // Create an invoice document in Firestore
//     FirebaseFirestore.instance.collection('invoices').add({
//       'sellerId': sellerId,
//       'buyerId': buyerId,
//       'productId': product.id,
//       'productName': product.name,
//       'quantity': quantity,
//       'price': product.price,
//       'totalPrice': product.price * quantity,
//       'timestamp': FieldValue.serverTimestamp(),
//     }).then((invoiceRef) {
//       // Navigate to the invoice page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => InvoicePage(invoiceRef.id),
//         ),
//       );
//     });
//   }
// }

import 'package:fam1/Screens/Cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:fam1/Data/Datamanger.dart';
import 'package:fam1/Screens/Cart/invoicepage.dart';

class ProductViewPage extends StatefulWidget {
  final Product product;

  const ProductViewPage({
    Key? key,
    required this.product, required Map<String, dynamic> productData, required Map<String, dynamic> id,
  }) : super(key: key);

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  int selectedQuantity = 1;
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    cartController = Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(widget.product.imageUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.product.name,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Price: \$${widget.product.price}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 18.0),
                ),
                DropdownButton<int>(
                  value: selectedQuantity,
                  items: List.generate(10, (index) => index + 1)
                      .map((quantity) => DropdownMenuItem<int>(
                            value: quantity,
                            child: Text('$quantity'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value ?? 1;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await cartController.addToCart(
                    widget.product, selectedQuantity);
                await DataManager().uploadProductToFirestore(widget.product);
                createInvoice(context, widget.product, selectedQuantity);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart),
                    SizedBox(width: 8.0),
                    Text('Add to Cart & Generate Invoice'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createInvoice(BuildContext context, Product product, int quantity) {
    String? sellerId = ''; // Fetch seller ID from the product data

    String buyerId = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance.collection('invoices').add({
      'sellerId': sellerId,
      'buyerId': buyerId,
      'productId': product.id,
      'productName': product.name,
      'quantity': quantity,
      'price': product.price,
      'totalPrice': product.price * quantity,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((invoiceRef) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoicePage(invoiceRef.id),
        ),
      );
    });
  }
}
