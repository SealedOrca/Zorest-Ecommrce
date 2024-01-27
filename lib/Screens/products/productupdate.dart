import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam1/Data/Datamanger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Product {
  final String name;
  final double price;
  final String userId;
  final String category;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.userId,
    required this.category,
    required this.imageUrl,
  });
}

class ProductUploadPage extends StatefulWidget {
  const ProductUploadPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductUploadPageState createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  late XFile _imageFile;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  String _selectedCategory = 'Default'; // Assume a default category

  @override
  void initState() {
    super.initState();
    _imageFile = XFile('');
  }

  Future<void> _pickImage() async {
  final imagePicker = ImagePicker();
  try {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = XFile(pickedFile.path);
      }
    });
  } catch (e) {
    // Handle exceptions if needed
    if (kDebugMode) {
      print('Error picking image: $e');
    }
  }
}


  Future<void> _uploadProduct() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await DataManager().init();

    if (_productNameController.text.isNotEmpty &&
        _productPriceController.text.isNotEmpty) {
      String imageUrl = await _uploadImageToStorage();

      if (imageUrl.isNotEmpty) {
        try {
          // Generate a unique product ID
          String productId = FirebaseFirestore.instance.collection('products').doc().id;

          Product product = Product(
            // Add the generated product ID
            name: _productNameController.text,
            price: double.parse(_productPriceController.text),
            userId: user.uid,
            category: _selectedCategory,
            imageUrl: imageUrl,
          );

          await FirebaseFirestore.instance.collection('products').doc(productId).set({
            'productId': productId,
            'name': product.name,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'userId': product.userId,
            'category': product.category,
          });

          _productNameController.clear();
          _productPriceController.clear();
          setState(() {
            _imageFile = XFile('');
          });

          // Print statements for debugging
          if (kDebugMode) {
            print('Product uploaded successfully:');
          }
          if (kDebugMode) {
            print('User ID: ${user.uid}');
          }
          if (kDebugMode) {
            print('Product ID: $productId');
          }
          if (kDebugMode) {
            print('Product Name: ${product.name}');
          }
          if (kDebugMode) {
            print('Product Price: ${product.price}');
          }
          if (kDebugMode) {
            print('Image URL: ${product.imageUrl}');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error uploading product: $e');
          }
        }
      } else {
        // Handle case where imageUrl is empty
      }
    }
  }
}


  Future<String> _uploadImageToStorage() async {
    if (_imageFile.path.isNotEmpty) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');

      await storageReference.putFile(File(_imageFile.path));

      return await storageReference.getDownloadURL();
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageFile.path.isEmpty
                    ? const Center(child: Icon(Icons.add_a_photo))
                    : Image.file(File(_imageFile.path), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _productPriceController,
              decoration: const InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8.0),
            _buildCategoryDropdown(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadProduct,
              child: const Text('Upload Product'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
  // Replace this with your actual category options
  List<String> categories = ['Seeds', 'Fertilizer', 'Plants', 'Crops', 'Electronic', 'Machines'];

  // Ensure that _selectedCategory is a valid category
  if (!categories.contains(_selectedCategory)) {
    _selectedCategory = categories.first; // Set to the first category as default
  }

  return DropdownButtonFormField<String>(
    value: _selectedCategory,
    onChanged: (value) {
      setState(() {
        _selectedCategory = value!;
      });
    },
    items: categories.map((category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Text(category),
      );
    }).toList(),
    decoration: const InputDecoration(labelText: 'Category'),
  );
}

}
