// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:fam1/controller/controller.dart';

// class ProductUploadPage extends StatefulWidget {
//   @override
//   _ProductUploadPageState createState() => _ProductUploadPageState();
// }

// class _ProductUploadPageState extends State<ProductUploadPage> {
//   final DatabaseController _dbController = DatabaseController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController(); // New controller for amount
//   List<File> _selectedImages = [];
//   String _selectedCategory = 'All';

//   Future<void> _pickImages() async {
//     final picker = ImagePicker();
//     final pickedImages = await picker.pickMultiImage();
//     if (pickedImages != null) {
//       setState(() {
//         _selectedImages = pickedImages.map((image) => File(image.path)).toList();
//       });
//     }
//   }

//   Future<void> _uploadProduct() async {
//     String name = _nameController.text;
//     String description = _descriptionController.text;
//     double price = double.tryParse(_priceController.text) ?? 0.0;
//     int amount = int.tryParse(_amountController.text) ?? 0; // Get amount from text field

//     try {
//       await _dbController.uploadProduct(
//         name: name,
//         description: description,
//         price: price,
//         category: _selectedCategory,
//         imageFiles: _selectedImages,
//         reviews: [],
//         attributes: {},
//         available: true,
//         shippingInfo: {},
//         favorite: false,
//         amount: amount, // Pass amount to uploadProduct method
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Product uploaded successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print('Error uploading product: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to upload product. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Product'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(bottom: 16.0),
//                 height: 100,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: IconButton(
//                   onPressed: _pickImages,
//                   icon: const Icon(Icons.camera_alt_rounded),
//                   iconSize: 50.0,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Product Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 5,
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(
//                   labelText: 'Price',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _amountController,
//                 decoration: const InputDecoration(
//                   labelText: 'Amount',
//                   border: OutlineInputBorder(),
//                 ),
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
//                 onPressed: _uploadProduct,
//                 child: const Text('Upload Product'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
