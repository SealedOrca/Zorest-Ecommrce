// import 'package:fam1/Screens/Cartsection/payment.dart';
// import 'package:fam1/controller/cartcontroller.dart';
// import 'package:fam1/controller/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:fam1/Screens/Home%20parts/Homescreens.dart';

// class CheckoutPage extends StatefulWidget {
//   final String userId; // User ID
//   final List<CartItem> cartItems; // Cart items

//   const CheckoutPage({super.key, required this.userId, required this.cartItems});

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   TextEditingController streetController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController postalCodeController = TextEditingController();
//   TextEditingController cardNumberController = TextEditingController();
//   TextEditingController expiryDateController = TextEditingController();
//   TextEditingController cvvController = TextEditingController();

//   bool _isProcessingPayment = false;

//   @override
//   Widget build(BuildContext context) {
//     double totalAmount = 0;
//     for (var item in widget.cartItems) {
//       totalAmount += item.price;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               'Cart Items:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // Display cart items with images
//             ...widget.cartItems.map((item) => Padding(
//               padding: const EdgeInsets.only(bottom: 10.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                       image: DecorationImage(
//                         image: NetworkImage(item.imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.productName,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           '\Rs${item.price.toStringAsFixed(2)}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//             const Divider(),
//             const SizedBox(height: 20),
//             const Text(
//               'Address Information:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // Address input fields
//             buildTextField('Street', streetController),
//             const SizedBox(height: 10),
//             buildTextField('City', cityController),
//             const SizedBox(height: 10),
//             buildTextField('State', stateController),
//             const SizedBox(height: 10),
//             buildTextField('Postal Code', postalCodeController),
//             const SizedBox(height: 20),
//             const Divider(),
//             const SizedBox(height: 20),
//             const Text(
//               'Payment Information:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // Payment page section
//             PaymentPage(
//               cardNumberController: cardNumberController,
//               expiryDateController: expiryDateController,
//               cvvController: cvvController,
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Total:',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '\$${totalAmount.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isProcessingPayment ? null : _processPayment,
//               child: _isProcessingPayment ? const CircularProgressIndicator() : const Text('Pay Now'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(String labelText, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   void _processPayment() async {
//     try {
//       // Set processing flag to true
//       setState(() {
//         _isProcessingPayment = true;
//       });

//       // Get address data
//       String street = streetController.text;
//       String city = cityController.text;
//       String state = stateController.text;
//       String postalCode = postalCodeController.text;

//       // Get card data
//       String cardNumber = cardNumberController.text;
//       String expiryDate = expiryDateController.text;
//       String cvv = cvvController.text;

//       // Assuming payment is successful, create receipts and clear cart
//       await _createReceiptsAndClearCart(street, city, state, postalCode, cardNumber, expiryDate, cvv);

//       // Show a confirmation message on the home screen
//       _showConfirmationMessage();
//     } catch (e) {
//       // Handle payment failure
//       _handlePaymentFailure(e);
//     } finally {
//       // Reset processing flag to false
//       setState(() {
//         _isProcessingPayment = false;
//       });
//     }
//   }

//   Future<void> _createReceiptsAndClearCart(String street, String city, String state, String postalCode, String cardNumber, String expiryDate, String cvv) async {
//     await DatabaseController().createReceipt(
//       cartItems: widget.cartItems,
//       buyerId: widget.userId,
//       sellerId: widget.cartItems.first.sellerId,
//       street: street,
//       city: city,
//       state: state,
//       postalCode: postalCode,
//       cardNumber: cardNumber,
//       expiryDate: expiryDate,
//       cvv: cvv,
//     );

//     await DatabaseController().createReceipt(
//       cartItems: widget.cartItems,
//       buyerId: widget.cartItems.first.sellerId,
//       sellerId: widget.userId,
//       street: street,
//       city: city,
//       state: state,
//       postalCode: postalCode,
//       cardNumber: cardNumber,
//       expiryDate: expiryDate,
//       cvv: cvv,
//     );

//     // Remove purchased items from the cart
//     for (var cartItem in widget.cartItems) {
//       await DatabaseController().removeFromCart(cartItem.id);
//     }
//   }

//   void _showConfirmationMessage() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => HomeScreen(
//           userId: widget.userId,
//           productData: const {}, // Provide product data here if needed
//         ),
//       ),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Items bought successfully')),
//     );
//   }

//   void _handlePaymentFailure(dynamic error) {
//     print('Error during payment: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Error during payment. Please try again later.')),
//     );
//   }
// }
import 'package:fam1/Screens/Cartsection/payment.dart';
import 'package:fam1/Screens/Home%20parts/Homescreens.dart';
import 'package:flutter/material.dart';
import 'package:fam1/controller/controller.dart';
import 'package:fam1/controller/cartcontroller.dart';


class CheckoutPage extends StatefulWidget {
  final String userId; // User ID
  final List<CartItem> cartItems; // Cart items

  const CheckoutPage({Key? key, required this.userId, required this.cartItems}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    int totalQuantity = 0;

    // Calculate total amount and total quantity
    widget.cartItems.forEach((item) {
      totalAmount += item.price * item.quantity;
      totalQuantity += item.quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Cart Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display cart items with quantities
            ...widget.cartItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.productName} (x${item.quantity})',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Total: \Rs${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Address Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Address input fields
            buildTextField('Street', streetController),
            const SizedBox(height: 10),
            buildTextField('City', cityController),
            const SizedBox(height: 10),
            buildTextField('State', stateController),
            const SizedBox(height: 10),
            buildTextField('Postal Code', postalCodeController),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Payment Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Payment page section
            PaymentPage(
              cardNumberController: cardNumberController,
              expiryDateController: expiryDateController,
              cvvController: cvvController,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Quantity: $totalQuantity',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total Amount: \Rs${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessingPayment ? null : _processPayment,
              child: _isProcessingPayment ? const CircularProgressIndicator() : const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _processPayment() async {
    try {
      // Set processing flag to true
      setState(() {
        _isProcessingPayment = true;
      });

      // Get address data
      String street = streetController.text;
      String city = cityController.text;
      String state = stateController.text;
      String postalCode = postalCodeController.text;

      // Get card data
      String cardNumber = cardNumberController.text;
      String expiryDate = expiryDateController.text;
      String cvv = cvvController.text;

      // Assuming payment is successful, create receipts and clear cart
      await _createReceiptsAndClearCart(street, city, state, postalCode, cardNumber, expiryDate, cvv);

      // Show a confirmation message on the home screen
      _showConfirmationMessage();
    } catch (e) {
      // Handle payment failure
      _handlePaymentFailure(e);
    } finally {
      // Reset processing flag to false
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  Future<void> _createReceiptsAndClearCart(String street, String city, String state, String postalCode, String cardNumber, String expiryDate, String cvv) async {
    await DatabaseController().createReceipt(
      cartItems: widget.cartItems,
      buyerId: widget.userId,
      sellerId: widget.cartItems.first.sellerId,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
    );

    await DatabaseController().createReceipt(
      cartItems: widget.cartItems,
      buyerId: widget.cartItems.first.sellerId,
      sellerId: widget.userId,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
    );

    // Remove purchased items from the cart
    for (var cartItem in widget.cartItems) {
      await DatabaseController().removeFromCart(cartItem.id);
    }
  }

  void _showConfirmationMessage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userId: widget.userId,
          productData: const {}, // Provide product data here if needed
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Items bought successfully')),
    );
  }

  void _handlePaymentFailure(dynamic error) {
    print('Error during payment: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error during payment. Please try again later.')),
    );
  }
}
