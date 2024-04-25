
import 'package:fam1/Screens/Setting/about.dart';
import 'package:fam1/Screens/Setting/acount.dart';
import 'package:fam1/Screens/Setting/paymentm.dart';
import 'package:fam1/Screens/Setting/privacy.dart';
import 'package:fam1/Screens/Setting/termcon.dart';
import 'package:fam1/Screens/login/Register/siginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settingpage extends StatelessWidget {
  final String userId; // Add this line

  const Settingpage({Key? key, required this.userId}) : super(key: key); // Modify the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Profile Section
                _buildUserProfileSection(context),

                // Navigation Links
                _buildNavigationLinks(context),

                // Account Details
                _buildAccountDetails(),

                // Logout Button
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


 Widget _buildUserProfileSection(BuildContext context) {
  User? user = FirebaseAuth.instance.currentUser;

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      Map<String, dynamic> userData = snapshot.data?.data() as Map<String, dynamic>;
      String profileImageUrl = userData['profilePicture'] ?? ''; // Use 'profilePicture' field
      String name = userData['name'] ?? 'John Doe'; // Fetch name properly

      return Column(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the user profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage()),
              );
            },
            child: Container(
              width: 160.0,
              height: 160.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue,
                    Colors.green,
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: _buildProfileImage(profileImageUrl),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? 'john.doe@example.com',
            style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
        ],
      );
    },
  );
}

ImageProvider _buildProfileImage(String? imageUrl) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      return NetworkImage(imageUrl);
    } catch (e) {
      print('Error loading profile image: $e');
      return const AssetImage('assets/album.jpg'); // Fallback image
    }
  } else {
    return const AssetImage('assets/album.jpg');
  }
}

  Widget _buildNavigationLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNavigationLink(
          context,
          'Accounts',
          Icons.book,
          const UserProfilePage(),
        ),
        _buildNavigationLink(
          context,
          'Payment Method',
          Icons.payment,
           PaymentMethodPage(userId: userId), // Pass userId here
        ),
        _buildNavigationLink(
          context,
          'Privacy Policy',
          Icons.privacy_tip,
          const PrivacyPolicyPage(),
        ),
        _buildNavigationLink(
          context,
          'Terms & Condition',
          Icons.policy,
          const TermsAndConditionsPage(),
        ),
        _buildNavigationLink(
          context,
          'About',
          Icons.info,
          const AboutPage(),
        ),
      ],
    );
  }

  Widget _buildNavigationLink(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildAccountDetails() {
    // Add widgets to display and edit account details
    return Container(
      // Your account details widgets go here
    );
  }

 Widget _buildLogoutButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()), // Replace SignInPage with your actual login page
        );
      } catch (e) {
        print('Error during logout: $e');
        // Handle any errors during the logout process
      }
    },
    child: const Text('Log Out'),
  );
}

}
