import 'package:flutter/material.dart';
import 'package:fam1/Admin_Section/add_product.dart';
import 'package:fam1/Admin_Section/bought.dart';
import 'package:fam1/Admin_Section/producteditpage.dart';
import 'package:fam1/Admin_Section/sold.dart';


class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Section'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildTile(context, ' Add Product ', Icons.shopping_basket, const ProductUploadPage()),
            _buildTile(context, 'Product Edit', Icons.edit, const UserProductsPage()),
            // _buildTile(context, 'Bought Receipts', Icons.monetization_on, const BoughtItemsPage()),
            _buildTile(context, 'Bought Receipts &Sold Receipts', Icons.monetization_on, SoldItemsPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData iconData, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 48.0, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

