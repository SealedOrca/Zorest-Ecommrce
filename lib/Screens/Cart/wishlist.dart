import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListPage extends StatelessWidget {
  final WishListController wishListController = Get.put(WishListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wish List'),
      ),
      body: Obx(
        () {
          final wishList = wishListController.wishList;
          return wishList.isEmpty
              ? Center(
                  child: Text('Your wish list is empty.'),
                )
              : ListView.builder(
                  itemCount: wishList.length,
                  itemBuilder: (context, index) {
                    final product = wishList[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: product.imageUrl != null
                            ? Image.network(product.imageUrl!)
                            : Icon(Icons.image),
                        title: Text(product.name),
                        subtitle: Text('Price: \$${product.price.toString()}'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            wishListController.removeFromWishList(product);
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          wishListController.addToWishList(); // Add a product to the wish list
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class WishListController extends GetxController {
  RxList<Product> wishList = <Product>[].obs;

  void addToWishList() {
    // Simulate adding a product to the wish list
    wishList.add(
      Product(
        name: 'New Product',
        price: 19.99,
        imageUrl:
            'https://example.com/new_product.jpg', // Replace with a valid URL
      ),
    );
  }

  void removeFromWishList(Product product) {
    wishList.remove(product);
  }
}

class Product {
  String? id;
  final String name;
  final double price;
  final String? imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });
}

void main() {
  runApp(MaterialApp(
    home: WishListPage(),
  ));
}
