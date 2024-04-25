import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam1/Screens/Home%20parts/categories.dart';
import 'package:fam1/Screens/products/product_viewpage.dart';
import 'package:fam1/controller/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeContent extends StatefulWidget {
  final DatabaseController dbController;
  final String userId; // Add userId parameter

  const HomeContent({super.key, required this.dbController, required this.userId});

  @override
  _HomeContentState createState() => _HomeContentState();
}


class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> productNames = [];
  String? searchQuery;
  bool showDropdown = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchProductNames();
    _fetchUserName();
  }

  Future<void> fetchProductNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      setState(() {
        productNames =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (error) {
      print('Error fetching product names: $error');
    }
  }

  Future<void> _fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic>? userData =
            await widget.dbController.getUserData(user.uid);
        print('User data: $userData');
        if (userData != null && userData.containsKey('name')) {
          setState(() {
            _userName = userData['name'];
          });
        } else {
          print('Name data is null or empty');
          setState(() {
            _userName = 'Guest';
          });
        }
      } else {
        print('User is null');
        setState(() {
          _userName = 'Guest';
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<String> _fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? ''; // Return userId or empty string
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            _userName != null ? 'Welcome, $_userName!' : 'Welcome!',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enableInfiniteScroll: true,
            autoPlay: true,
          ),
          items: const [
            ProductCard1(
              imageUrl: 'https://img.freepik.com/free-photo/photocomposition-horizontal-shopping-banner-with-woman-big-smartphone_23-2151201773.jpg?w=826&t=st=1711599453~exp=1711600053~hmac=ee49d9aad60c0be28fa8c0eae7f993749d8fd76285774a98019e151356f390c3',
            ),
            ProductCard1(
              imageUrl: 'https://propellerads.com/blog/wp-content/uploads/2024/02/Propellerads-ecommerce-offers-guide-main-1024x512.webp',
            ),
            ProductCard1(
              imageUrl: 'https://img.freepik.com/free-vector/application-smartphone-mobile-computer-payments-online-transaction-shopping-online-process-smartphone-vecter-cartoon-illustration-isometric-design_1150-62437.jpg?w=900&t=st=1711599464~exp=1711600064~hmac=fdd33651d404fd9441ce629fc18d7f82f03d0cc37262326369f73f808793b420',
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryButton(Icons.grass, 'Seeds'),
                    _buildCategoryButton(Icons.local_florist, 'Plants'),
                    _buildCategoryButton(Icons.landscape, 'Crops'),
                    _buildCategoryButton(Icons.settings_input_antenna, 'Electronics'),
                    _buildCategoryButton(Icons.build, 'Machines'),
                    _buildCategoryButton(Icons.grass, 'Fertilizer'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
        DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Newest'),
                    Tab(text: 'Popular'),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const TabBarView(
                  children: [
                    HomeProductList(),
                    HomeProductList(),
                    HomeProductList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


 Widget _buildCategoryButton(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: InkWell(
      onTap: () async {
        try {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(
                category: text,
                dbController: widget.dbController,
                userId: widget.userId,
              ),
            ),
          );
        } catch (e) {
          print('Error navigating to category page: $e');
        }
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 86, 150, 107),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 30, // Adjust icon size
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
    }


// Used to fetch data from firebase to homescree
class HomeProductList extends StatefulWidget {
  const HomeProductList({Key? key}) : super(key: key);

  @override
  _HomeProductListState createState() => _HomeProductListState();
}

class _HomeProductListState extends State<HomeProductList> {
  final DatabaseController _databaseController = DatabaseController();
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _databaseController.getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<Map<String, dynamic>>? products = snapshot.data;
          if (products == null || products.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> productData = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductViewPage(productData: productData, userId: _userId),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4, // Add elevation for shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Add border radius
                      side: BorderSide(color: Colors.grey.shade300, width: 1), // Add outline
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width > 600 ? 280 : 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(productData['imageUrls'][0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productData['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  productData['description'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\Rs${productData['price']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 86, 150, 107),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}


class ProductCardView extends StatelessWidget {
  const ProductCardView({
    Key? key,
    required this.productData,
    this.imageAlignment = Alignment.bottomCenter,
    this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> productData;
  final Alignment imageAlignment;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final String productName = productData['name'];
    final String productPrice = productData['price'];
    final String productImage = productData['imageUrl'];
    final bool isSpecialOffer = productData['isSpecialOffer'];

    final priceValue =
        (productPrice.isNotEmpty && isSpecialOffer) ? productPrice : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        width: 120, // Limiting width to avoid overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                SizedBox(
                  height: 100, // Set a specific height for the image container
                  width: double.infinity,
                  child: Image.network(
                    productImage,
                    alignment: imageAlignment,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isSpecialOffer)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      ' ON SALE ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            backgroundColor: Colors.pink,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 120, // Limiting width to avoid overflow
              child: Text(
                productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 120, // Limiting width to avoid overflow
              child: Text(
                '${priceValue ?? ''} €',
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProductCard1 extends StatelessWidget {
  final String imageUrl;

  const ProductCard1({super.key, 
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        height: 150.0, // Set a specific height to avoid pixel overflow
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

