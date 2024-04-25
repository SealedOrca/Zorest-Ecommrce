// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fam1/controller/controller.dart';
// import 'package:fam1/Screens/Home%20parts/Saerch.dart';
// import 'package:fam1/Screens/Home%20parts/fav.dart';
// import 'package:fam1/Screens/Cartsection/cart_screen.dart';
// import 'package:fam1/Screens/Setting/setting.dart';
// import 'package:fam1/Screens/Home%20parts/homecontent.dart';

// class HomeScreen extends StatefulWidget {
//   final String userId;
//   final Map<String, dynamic> productData;

//   const HomeScreen({Key? key, required this.userId, required this.productData}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final DatabaseController _dbController = DatabaseController();
//   int _selectedIndex = 0;
//   late List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       HomeContent(dbController: _dbController, userId: widget.userId),
//       FavScreen(userId: widget.userId),
//       CartPage(userId: widget.userId, productData: widget.productData),
//       Settingpage(userId: widget.userId),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)),
//               );
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             _buildDrawerHeader(context),
//             const SizedBox(height: 20),
//             _buildDrawerItem(
//               icon: Icons.home,
//               text: 'Home',
//               onTap: () => _navigateToPage(0),
//             ),
//             const Divider(),
//             _buildDrawerItem(
//               icon: Icons.favorite,
//               text: 'Favorites',
//               onTap: () => _navigateToPage(1),
//             ),
//             const Divider(),
//             _buildDrawerItem(
//               icon: Icons.shopping_cart,
//               text: 'Cart',
//               onTap: () => _navigateToPage(2),
//             ),
//             const Divider(),
//             _buildDrawerItem(
//               icon: Icons.settings,
//               text: 'Settings',
//               onTap: () => _navigateToPage(3),
//             ),
//             const Divider(),
//           ],
//         ),
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) => setState(() {
//           _selectedIndex = index;
//         }),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite_border_outlined),
//             label: 'Favourite',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerHeader(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     return DrawerHeader(
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         image: const DecorationImage(
//           image: AssetImage('assets/drawer_bg.jpg'), // Replace with your actual drawer background image
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const CircleAvatar(
//             radius: 30.0,
//             backgroundImage: NetworkImage('https://example.com/profile-image.jpg'), // Replace with user's profile image URL
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             user?.displayName ?? 'User',
//             style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           Text(
//             user?.email ?? 'example@example.com',
//             style: const TextStyle(fontSize: 14.0, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(text),
//       onTap: onTap,
//     );
//   }

//   void _navigateToPage(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     Navigator.pop(context);
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fam1/controller/controller.dart';
import 'package:fam1/Screens/Home%20parts/Saerch.dart';
import 'package:fam1/Screens/Home%20parts/fav.dart';
import 'package:fam1/Screens/Cartsection/cart_screen.dart';
import 'package:fam1/Screens/Setting/setting.dart';
import 'package:fam1/Screens/Home%20parts/homecontent.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> productData;

  const HomeScreen({Key? key, required this.userId, required this.productData}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseController _dbController = DatabaseController();
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(dbController: _dbController, userId: widget.userId),
      FavScreen(userId: widget.userId),
      CartPage(userId: widget.userId, productData: widget.productData),
      Settingpage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            const SizedBox(height: 20),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => _navigateToPage(0),
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.favorite,
              text: 'Favorites',
              onTap: () => _navigateToPage(1),
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.shopping_cart,
              text: 'Cart',
              onTap: () => _navigateToPage(2),
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => _navigateToPage(3),
            ),
            const Divider(),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: const DecorationImage(
          image: AssetImage('assets/drawer_bg.jpg'), // Replace with your actual drawer background image
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage('https://example.com/profile-image.jpg'), // Replace with user's profile image URL
          ),
          const SizedBox(height: 8.0),
          Text(
            user?.displayName ?? 'User',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            user?.email ?? 'example@example.com',
            style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }
}
