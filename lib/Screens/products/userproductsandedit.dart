// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fam1/controller/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProductEditPage extends StatefulWidget {
//   final String productId;

//   ProductEditPage({required this.productId});

//   @override
//   _ProductEditPageState createState() => _ProductEditPageState();
// }

// class _ProductEditPageState extends State<ProductEditPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   String _selectedCategory = 'All';

//   @override
//   void initState() {
//     super.initState();
//     // Fetch the product data when the page loads
//     _fetchProductData();
//   }

//   Future<void> _fetchProductData() async {
//     try {
//       // Fetch the product data based on the provided productId
//       DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .doc(widget.productId)
//           .get();

//       // Populate the text controllers and selected category with the fetched data
//       setState(() {
//         _nameController.text = productSnapshot['name'];
//         _descriptionController.text = productSnapshot['description'];
//         _priceController.text = productSnapshot['price'].toString();
//         _selectedCategory = productSnapshot['category'];
//       });
//     } catch (e) {
//       print('Error fetching product data: $e');
//       // Handle error
//     }
//   }

//   Future<void> _updateProduct() async {
//     try {
//       // Validate input
//       if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
//         // Show error message if any field is empty
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please fill in all fields.'),
//           ),
//         );
//         return;
//       }

//       // Validate price
//       if (!isNumeric(_priceController.text)) {
//         // Show error message if price is not numeric
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please enter a valid price.'),
//           ),
//         );
//         return;
//       }

//       // Prepare the updated product data
//       Map<String, dynamic> updatedProductData = {
//         'name': _nameController.text,
//         'description': _descriptionController.text,
//         'price': double.parse(_priceController.text),
//         'category': _selectedCategory,
//       };

//       // Edit the product and get updated user products
//       String userId = FirebaseAuth.instance.currentUser!.uid;
//       await DatabaseController().editAndGetUserProducts(widget.productId, updatedProductData, userId);

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Product updated successfully.'),
//         ),
//       );

//       // Navigate back to previous screen
//       Navigator.pop(context);
//     } catch (e) {
//       // Handle error
//       print('Error updating product: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to update product. Please try again later.'),
//         ),
//       );
//     }
//   }

//   // Function to check if a string is numeric
//   bool isNumeric(String s) {
//     if (s == null) {
//       return false;
//     }
//     return double.tryParse(s) != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Product'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Product Name'),
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 maxLines: 5,
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 children: [
//                   const Text('Category:', style: TextStyle(fontSize: 16)),
//                   const SizedBox(width: 10),
//                   DropdownButton<String>(
//                     value: _selectedCategory,
//                     items: [
//                       'All',
//                       'Seeds',
//                       'Fertilizer',
//                       'Plants',
//                       'Crops',
//                       'Electronics',
//                       'Machines'
//                     ].map((category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedCategory = value!;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _updateProduct,
//                 child: const Text('Update Product'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
