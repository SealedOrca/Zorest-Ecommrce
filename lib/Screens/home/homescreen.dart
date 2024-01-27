import 'dart:math';
import 'package:fam1/Data/Datamanger.dart';
import 'package:fam1/Screens/Cart/cart.dart';
import 'package:fam1/Screens/Cart/invoiced.dart';
import 'package:fam1/Screens/Cart/paymentmethod.dart';
import 'package:fam1/Screens/Setting/about.dart';
import 'package:fam1/Screens/Setting/privacy.dart';
import 'package:fam1/Screens/Setting/setting.dart';
import 'package:fam1/Screens/home/cat.dart';
import 'package:fam1/Screens/home/searchpage.dart';
import 'package:fam1/Screens/products/pd.dart';
import 'package:fam1/Screens/products/productupdate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeContent(),
    const Settingpage(),
  ];

  final List<Map<String, dynamic>> _cart = [];
  final CartController _cartController = CartController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zorest'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ); // Handle search icon tap
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart icon tap
              _openCart();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(135, 242, 253, 238),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(1.0),
                    bottomRight: Radius.circular(1.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Lottie.asset(
                        'assets/f2.json', // Replace with your Lottie animation file
                        width: 320, // Adjust the width as needed
                        height: 350, // Adjust the height as needed
                      ),
                    ),
                    const Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildListTile('Home', Icons.home, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildListTile('Product Upload', Icons.file_upload, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductUploadPage()),
                );
              }),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildListTile('Own Product Display', Icons.view_list, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDisplayPage()),
                );
              }),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildListTile('Transaction History', Icons.history, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TransactionHistoryPage()),
                );
              }),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildListTile('Settings', Icons.account_circle, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settingpage()),
                );
              }),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildListTile('Payment Method', Icons.payment, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TransactionHistoryPage()),
                );
              }),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildListTile('Privacy Policy', Icons.security, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                );
              }),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildListTile('About', Icons.info, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ListTile _buildListTile(String title, IconData icon, Function onTap) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () => onTap(),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    );
  }

  void _checkout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DummyPaymentPage(
          onPaymentComplete: () {
            // Payment completed, clear the cart
            _cart.clear();
            // You can navigate to an order confirmation page or any other page
            // based on your application flow.
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: 850,
            child: CarouselSlider(
              items: const [
                'https://m.media-amazon.com/images/I/51omsKzExeL._AC_SL1000_.jpg',
                'https://m.media-amazon.com/images/I/61UYDMjY3oL._AC_SL1024_.jpg',
                'https://m.media-amazon.com/images/I/61aeFZsPP-L._AC_SX569_.jpg',
                'https://m.media-amazon.com/images/I/61tOzLIrReL._AC_SL1080_.jpg',
                'https://m.media-amazon.com/images/I/61xSkbEz2XL._AC_.jpg',
                'https://m.media-amazon.com/images/I/71ebnf810EL._AC_SX679_.jpg',
              ].map((item) => Image.network(item, fit: BoxFit.cover)).toList(),
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildCategoryCards(),
          const SizedBox(height: 16),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildCategoryCards() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryCard(
            'Seeds',
            'https://hips.hearstapps.com/hmg-prod/images/flaxseed-close-up-royalty-free-image-1636392298.jpg?resize=980:*',
          ),
          _buildCategoryCard(
            'Fertilizer',
            'https://canoladigest.ca/wp-content/uploads/2022/01/26-right-placee-fertilizer-feature-min.jpg',
          ),
          _buildCategoryCard(
            'Plants',
            'https://hips.hearstapps.com/hmg-prod/images/plant-guide-1663941701.jpg?crop=0.841xw:1.00xh;0.0817xw,0&resize=1200:*',
          ),
          _buildCategoryCard(
            'Crops',
            'https://images.nationalgeographic.org/image/upload/t_edhub_resource_key_image/v1638892233/EducationHub/photos/crops-growing-in-thailand.jpg',
          ),
          _buildCategoryCard(
            'Electronics',
            'https://media.licdn.com/dms/image/D5612AQFmOGUY5y_vuw/article-cover_image-shrink_720_1280/0/1686425431819?e=1710979200&v=beta&t=iw5GNIy1d-iFhqugW7V8m2-Kj3IsPkmU-q1GZ2_Kwow',
          ),
          _buildCategoryCard(
            'Machines',
            'https://upload.wikimedia.org/wikipedia/commons/0/08/Agricultural_machinery.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, String imageUrl) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // Navigate to the respective category products page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryProductsPage(category: category),
            ),
          );
        },
        child: Container(
          height: 100, // Set a maximum height for the container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No products available.'),
          );
        }

        List<Map<String, dynamic>> products = snapshot.data!.docs
            .map((DocumentSnapshot document) =>
                document.data() as Map<String, dynamic>)
            .toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = products[index];
            return ProductCard(
              data: data,
              onAddToCart: () => _addToCart(data),
            );
          },
        );
      },
    );
  }

  void _addToCart(Map<String, dynamic> productData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${productData['name']} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function()? onAddToCart;

  const ProductCard({
    required this.data,
    this.onAddToCart,
    Key? key,
  }) : super(key: key);

  int _generateRandomStars() {
    return Random().nextInt(5) + 1; // Generates a random number between 1 and 5
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        width: 200,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      data['imageUrl'] ?? '',
                      width: 230,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(data['author'] ?? ''),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Row(
                              children: List.generate(
                                _generateRandomStars(),
                                (index) => const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${data['userCount'] ?? ''} Ratings',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\Pkr ${data['price'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
