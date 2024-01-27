import 'package:fam1/Screens/Setting/termcon.dart';
import 'package:fam1/login/Register/siginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _termsAndConditionsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mysterious-forest-landscape.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 28, color: Color.fromARGB(255, 199, 198, 198)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTextField(_nameController, 'Name'),
                const SizedBox(height: 10),
                _buildTextField(_emailController, 'Email'),
                const SizedBox(height: 10),
                _buildTextField(_passwordController, 'Password',
                    isPassword: true),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAndConditionsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAndConditionsAccepted = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to terms and conditions page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TermsAndConditionsPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'I accept the terms and conditions',
                        style: TextStyle(
                          color: Color.fromARGB(255, 199, 198, 198),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!_termsAndConditionsAccepted) {
                      _showSnackbar(
                          context, 'Please accept the terms and conditions.');
                      return;
                    }
                    await _register(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 199, 198, 198),
                    onPrimary: const Color.fromARGB(255, 247, 242, 242),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add),
                      SizedBox(width: 10),
                      Text('Register'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Already a member? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SignInPage(), // Navigate to sign-in page
                          ),
                        );
                      },
                      child: const Text(
                        'Already a member?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 199, 198, 198)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    try {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _showSnackbar(context, 'Please fill in all fields.');
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Default profile picture URL
      String defaultProfilePictureUrl =
          'gs://fam1-b4d5b.appspot.com/profile_images/album.jpg';

      // Save additional user data to Firestore with the generated user ID
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'userId': userId,
        'buyerId': userId,
        'profilePicture': defaultProfilePictureUrl,
      });

      if (kDebugMode) {
        print('User registered: $userId');
      }
      Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print('Registration failed: $e');
      }
      String errorMessage = _getRegistrationErrorMessage(e);
      _showSnackbar(context, errorMessage);
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _getRegistrationErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already in use. Please use a different email.';
        case 'weak-password':
          return 'The password is too weak. Please choose a stronger password.';
        default:
          return 'Registration failed. Please try again later.';
      }
    } else {
      return 'Registration failed. Please try again later.';
    }
  }
}
