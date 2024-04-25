import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam1/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductEditPage extends StatefulWidget {
  final String productId;

  const ProductEditPage({super.key, required this.productId});

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      setState(() {
        _nameController.text = productSnapshot['name'];
        _descriptionController.text = productSnapshot['description'];
        _priceController.text = productSnapshot['price'].toString();
        _selectedCategory = productSnapshot['category'];
      });
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }

  Future<void> _updateProduct() async {
    try {
      setState(() {
        _isUpdating = true;
      });

      if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields.'),
          ),
        );
        return;
      }

      if (!isNumeric(_priceController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid price.'),
          ),
        );
        return;
      }

      Map<String, dynamic> updatedProductData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
      };

      String userId = FirebaseAuth.instance.currentUser!.uid;
      await DatabaseController().editAndGetUserProducts(widget.productId, updatedProductData, userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully.'),
        ),
      );

      setState(() {
        _isUpdating = false;
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _selectedCategory = 'All';
      });
      
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      print('Error updating product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update product. Please try again later.'),
        ),
      );
    }
  }

  Future<void> _deleteProduct() async {
    try {
      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmDelete) {
        // Perform delete operation
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully.'),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete product. Please try again later.'),
        ),
      );
    }
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _deleteProduct,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Category:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    items: [
                      'All',
                      'Seeds',
                      'Fertilizer',
                      'Plants',
                      'Crops',
                      'Electronics',
                      'Machines'
                    ].map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (_isUpdating) // Show circular progress indicator if updating
                const Center(child: CircularProgressIndicator()),

              // Update Product button
              ElevatedButton(
                onPressed: _isUpdating ? null : _updateProduct, // Disable button if updating
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class UserProductsPage extends StatefulWidget {
  const UserProductsPage({super.key});

  @override
  _UserProductsPageState createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  List<Map<String, dynamic>> _userProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchUserProducts();
  }

  Future<void> _fetchUserProducts() async {
    try {
      // Fetch the current user
      User? currentUser = await DatabaseController().getCurrentUser();
      if (currentUser != null) {
        // Fetch products associated with the current user's ID
        List<Map<String, dynamic>> userProducts = await DatabaseController().getProductsByUserId(currentUser.uid);
        setState(() {
          _userProducts = userProducts;
        });
      } else {
        // Handle if no user is logged in
        print('No user logged in.');
      }
    } catch (e) {
      print('Error fetching user products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
      ),
      body: _userProducts.isEmpty
          ? const Center(
              child: Text('No products found.'),
            )
          : ListView.builder(
              itemCount: _userProducts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> product = _userProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('\Rs${product['price']}'),
                  onTap: () {
                    // Navigate to the product edit page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductEditPage(productId: product['productId']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
