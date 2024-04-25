// import 'package:fam1/Screens/Cartsection/checkoutpage.dart';
// import 'package:fam1/controller/cartcontroller.dart';
// import 'package:flutter/material.dart';
// import 'package:fam1/controller/controller.dart';




// class CartItemWidget extends StatelessWidget {
//   final CartItem cartItem;

//   const CartItemWidget({super.key, required this.cartItem});

//   @override
//   Widget build(BuildContext context) {
//     print('Image URL: ${cartItem.imageUrl}');
//     return ListTile(
//       leading: _buildProductImage(cartItem.imageUrl), // Use the _buildProductImage method
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             cartItem.productName,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text('Price: \Rs${cartItem.price.toStringAsFixed(2)}'), // Display the price
//         ],
//       ),
//       subtitle: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.remove),
//             onPressed: () {
//               // Decrease quantity
//               // Assuming you have a function to decrease quantity in DatabaseController
//               DatabaseController().decreaseQuantity(cartItem.id);
//             },
//           ),
//           Text('${cartItem.quantity}'),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               // Increase quantity
//               // Assuming you have a function to increase quantity in DatabaseController
//               DatabaseController().increaseQuantity(cartItem.id);
//             },
//           ),
//         ],
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.delete),
//         onPressed: () {
//           // Remove the item from the cart
//           DatabaseController().removeFromCart(cartItem.id).then((_) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Item removed from cart'),
//                 duration: Duration(seconds: 1),
//               ),
//             );
//           }).catchError((error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Failed to remove item: $error'),
//                 duration: const Duration(seconds: 1),
//               ),
//             );
//           });
//         },
//       ),
//     );
//   }
// Widget _buildProductImage(String? imageUrl) {
//   if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'No Image Available') {
//     return Image.network(
//       imageUrl,
//       width: 120,
//       height: 120,
//       fit: BoxFit.cover,
//     );
//   } else {
//     // Placeholder image or default image
//     return const Placeholder(
//       color: Colors.grey, // Placeholder color
//       fallbackHeight: 120,
//       fallbackWidth: 120,
//     );
//   }
// }
// }


// class CartPage extends StatefulWidget {
//   final String userId; // Add user ID as a parameter

//   const CartPage({super.key, required this.userId, required Map<String, dynamic> productData});

//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   late Future<List<CartItem>> _cartItemsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadCartItems();
//   }

//   void _loadCartItems() {
//     setState(() {
//       // Pass the user ID when calling getCartItems
//       _cartItemsFuture = DatabaseController().getCartItems(widget.userId);
//     });
//   }

//   void _navigateToCheckoutPage(BuildContext context, List<CartItem> cartItems) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CheckoutPage(cartItems: cartItems, userId: widget.userId),
//       ),
//     ).then((value) {
//       // Refresh cart items when returning from checkout page
//       _loadCartItems();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Cart'),
//       //   centerTitle: true,
//       // ),
//       body: FutureBuilder<List<CartItem>>(
//         future: _cartItemsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final List<CartItem>? cartItems = snapshot.data;
//             if (cartItems == null || cartItems.isEmpty) {
//               return const Center(child: Text('No items in the cart'));
//             } else {
//               return Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: cartItems.length,
//                       itemBuilder: (context, index) {
//                         return Dismissible(
//                           key: Key(cartItems[index].id),
//                           onDismissed: (_) {
//                             // Remove item from cart
//                             DatabaseController().removeFromCart(cartItems[index].id);
//                             // Refresh cart items
//                             _loadCartItems();
//                           },
//                           direction: DismissDirection.endToStart,
//                           background: Container(
//                             alignment: Alignment.centerRight,
//                             padding: const EdgeInsets.only(right: 20),
//                             color: Colors.red,
//                             child: const Icon(Icons.delete, color: Colors.white),
//                           ),
//                           child: CartItemWidget(cartItem: cartItems[index]),
//                         );
//                       },
//                     ),
//                   ),
//                   const Divider(),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Total Price:',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           calculateTotalPrice(cartItems).toStringAsFixed(2),
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       _navigateToCheckoutPage(context, cartItems);
//                     },
//                     child: const Text('Checkout'),
//                   ),
//                 ],
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   double calculateTotalPrice(List<CartItem> cartItems) {
//     double totalPrice = 0;
//     for (var item in cartItems) {
//       totalPrice += item.price * item.quantity;
//     }
//     return totalPrice;
//   }
// }
import 'package:fam1/Screens/Cartsection/checkoutpage.dart';
import 'package:flutter/material.dart';
import 'package:fam1/controller/cartcontroller.dart';
import 'package:fam1/controller/controller.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function() onUpdate;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Image URL: ${cartItem.imageUrl}');
    return ListTile(
      leading: _buildProductImage(cartItem.imageUrl),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cartItem.productName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Price: Rs${cartItem.price.toStringAsFixed(2)}'),
        ],
      ),
      subtitle: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              // Decrease quantity
              DatabaseController().decreaseQuantity(cartItem.id).then((_) {
                onUpdate(); // Update UI after quantity change
              });
            },
          ),
          Text('${cartItem.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Increase quantity
              DatabaseController().increaseQuantity(cartItem.id).then((_) {
                onUpdate(); // Update UI after quantity change
              });
            },
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // Remove the item from the cart
          DatabaseController().removeFromCart(cartItem.id).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item removed from cart'),
                duration: Duration(seconds: 1),
              ),
            );
            onUpdate(); // Update UI after item removal
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to remove item: $error'),
                duration: const Duration(seconds: 1),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'No Image Available') {
      return Image.network(
        imageUrl,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else {
      return const Placeholder(
        color: Colors.grey,
        fallbackHeight: 120,
        fallbackWidth: 120,
      );
    }
  }
}

class CartPage extends StatefulWidget {
  final String userId;

  const CartPage({
    Key? key,
    required this.userId, required Map<String, dynamic> productData,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartItem>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() async {
  setState(() {
    _cartItemsFuture = DatabaseController().getCartItems(widget.userId);
  });
  await _cartItemsFuture; // Wait for the cart items to be loaded
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CartItem>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<CartItem>? cartItems = snapshot.data;
            if (cartItems == null || cartItems.isEmpty) {
              return const Center(child: Text('No items in the cart'));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(cartItems[index].id),
                          onDismissed: (_) {
                            // Remove item from cart
                            DatabaseController().removeFromCart(cartItems[index].id).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Item removed from cart'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              _loadCartItems(); // Refresh cart items
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to remove item: $error'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            });
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: CartItemWidget(
                            cartItem: cartItems[index],
                            onUpdate: _loadCartItems, // Pass the method to update cart items
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          calculateTotalPrice(cartItems).toStringAsFixed(2),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToCheckoutPage(context, cartItems);
                    },
                    child: const Text('Checkout'),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  void _navigateToCheckoutPage(BuildContext context, List<CartItem> cartItems) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(cartItems: cartItems, userId: widget.userId),
      ),
    ).then((value) {
      // Refresh cart items when returning from checkout page
      _loadCartItems();
    });
  }

  double calculateTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }
}
