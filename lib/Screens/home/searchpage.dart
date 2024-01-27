import 'package:fam1/Data/Datamanger.dart';
import 'package:fam1/Screens/products/pdv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   late TextEditingController _searchController;
//   String _selectedCategory = 'All';
//   late Stream<QuerySnapshot<Map<String, dynamic>>> _productsStream;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _productsStream = _getProductsStream();
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> _getProductsStream() {
//     CollectionReference productsCollection =
//         FirebaseFirestore.instance.collection('products');

//     if (_selectedCategory == 'All') {
//       return productsCollection
//           .where('name', isGreaterThanOrEqualTo: '')
//           .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
//     } else {
//       return productsCollection
//           .where('category', isEqualTo: _selectedCategory)
//           .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Products'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           _buildSearchBar(),
//           _buildFilterDropdown(),
//           Expanded(
//             child: _buildProductList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           labelText: 'Search',
//           suffixIcon: IconButton(
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               setState(() {
//                 _searchController.clear();
//               });
//             },
//           ),
//         ),
//         onChanged: (value) {
//           setState(() {
//             _productsStream = _getProductsStream();
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildFilterDropdown() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           const Text('Filter by Category:'),
//           const SizedBox(width: 10),
//           DropdownButton<String>(
//             value: _selectedCategory,
//             items: [
//               'All',
//               'Seeds',
//               'Fertilizer',
//               'Plants',
//               'Crops',
//               'Electronics',
//               'Machines'
//             ].map((category) {
//               return DropdownMenuItem<String>(
//                 value: category,
//                 child: Text(category),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedCategory = value!;
//                 _productsStream = _getProductsStream();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductList() {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: _productsStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(
//             child: Text('No products found.'),
//           );
//         } else {
//           List<DocumentSnapshot<Map<String, dynamic>>> products =
//               snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               Map<String, dynamic> productData =
//                   products[index].data() as Map<String, dynamic>;

//               return ListTile(
//                 title: Text(productData['name']),
//                 subtitle: Text('${productData['price']}'),
//                 // Add more details as needed
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  String _selectedCategory = 'All';
  late Stream<QuerySnapshot<Map<String, dynamic>>> _productsStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _productsStream = _getProductsStream();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getProductsStream() {
    CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('products');

    if (_selectedCategory == 'All') {
      return productsCollection
          .where('name', isGreaterThanOrEqualTo: '')
          .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    } else {
      return productsCollection
          .where('category', isEqualTo: _selectedCategory)
          .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterDropdown(),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
              });
            },
          ),
        ),
        onChanged: (value) {
          setState(() {
            _productsStream = _getProductsStream();
          });
        },
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text('Filter by Category:'),
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
                _productsStream = _getProductsStream();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No products found.'),
          );
        } else {
          List<DocumentSnapshot<Map<String, dynamic>>> products =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> productData =
                  products[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductViewPage(
                        product: Product(
                          // Replace this with your product model or data.
                          id: productData['id'],
                          name: productData['name'],
                          price: productData['price'],
                          imageUrl: productData['imageUrl'],
                        ),
                        productData: productData, 
                        id: productData,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(productData['name']),
                  subtitle: Text('${productData['price']}'),
                  // Add more details as needed
                ),
              );
            },
          );
        }
      },
    );
  }
}
