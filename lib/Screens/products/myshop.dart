import 'package:fam1/Screens/Cart/invoiced.dart';
import 'package:fam1/Screens/products/pd.dart';
import 'package:fam1/Screens/products/productupdate.dart';
import 'package:flutter/material.dart';



class MyApp12 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shop App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyShopPage(),
    );
  }
}

class MyShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildListTile(
              context,
              title: 'Product Upload',
              page:  ProductUploadPage(),
            ),
            _buildListTile(
              context,
              title: 'Own Product Display',
              page:  ProductDisplayPage(),
            ),
            _buildListTile(
              context,
              title: 'Transaction History',
              page:  TransactionHistoryPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required String title, required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
