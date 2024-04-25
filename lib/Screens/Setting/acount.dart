import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late FirebaseAuth _auth;
  late User _user;
  late File? _userProfilePicture;
  late TextEditingController _userNameController;
  late TextEditingController _userEmailController;
  late TextEditingController _aboutController;

  bool _editMode = false;
@override
void initState() {
  super.initState();
  _auth = FirebaseAuth.instance;
  _user = _auth.currentUser!;
  _userProfilePicture = null;
  _userNameController = TextEditingController();
  _userEmailController = TextEditingController(text: _user.email);
  _aboutController = TextEditingController(text: '');

  _loadUserData();
}

Future<void> _loadUserData() async {
  try {
    // Reload the user to fetch the latest data
    await _user.reload();
    _user = _auth.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    if (userData.exists) {
      final about = userData['about'] as String?;
      final profilePicture = userData['profilePicture'] as String?;
      setState(() {
        _aboutController.text = about ?? '';
        _userNameController.text = _user.displayName ?? ''; // Fetch name properly
        if (profilePicture != null) {
          _userProfilePicture = File(profilePicture);
        }
      });
    }
  } catch (e) {
    print('Error loading user data: $e');
  }
}


  Future<void> _updateUserProfile() async {
    try {
      await _user.updateDisplayName(_userNameController.text);

      if (_userProfilePicture != null) {
        await _uploadProfilePicture();
      }

      if (mounted) {
        await FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
          'about': _aboutController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );

        setState(() {
          _editMode = false;
        });
      }
    } catch (e) {
      print('Error updating user profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _pickProfilePicture() async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _userProfilePicture = File(pickedFile.path);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
    }
  }

  Future<void> _uploadProfilePicture() async {
    try {
      if (_userProfilePicture != null) {
        String fileName = 'profile_picture_${_user.uid}';
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/$fileName.jpg');
        await storageReference.putFile(_userProfilePicture!);

        String downloadURL = await storageReference.getDownloadURL();

        await _user.updatePhotoURL(downloadURL);

        await FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
          'profilePicture': _userProfilePicture!.path,
        });
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (_editMode) {
                _updateUserProfile();
              }
              setState(() {
                _editMode = !_editMode;
              });
            },
            icon: Icon(_editMode ? Icons.check : Icons.edit),
          ),
        ],
      ),
      body: _editMode ? _buildEditModeContent() : _buildDisplayModeContent(),
    );
  }

  Widget _buildDisplayModeContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _pickProfilePicture(),
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  image: _user.photoURL != null
                      ? DecorationImage(
                          image: NetworkImage(_user.photoURL!),
                          fit: BoxFit.cover,
                        )
                      : _userProfilePicture != null
                          ? DecorationImage(
                              image: FileImage(_userProfilePicture!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: _user.photoURL == null && _userProfilePicture == null
                    ? const Center(child: Icon(Icons.add_a_photo))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileField('Name', _user.displayName ?? ''),
            const SizedBox(height: 10),
            _buildProfileField('Email', _user.email ?? 'No email available'),
            const SizedBox(height: 10),
            _buildProfileField('About', _aboutController.text),
          ],
        ),
      ),
    );
  }

  Widget _buildEditModeContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _pickProfilePicture(),
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  image: _userProfilePicture != null
                      ? DecorationImage(
                          image: FileImage(_userProfilePicture!),
                          fit: BoxFit.cover,
                        )
                      : _user.photoURL != null
                          ? DecorationImage(
                              image: NetworkImage(_user.photoURL!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: _userProfilePicture == null && _user.photoURL == null
                    ? const Center(child: Icon(Icons.add_a_photo))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildEditableProfileField('Name', _userNameController),
            const SizedBox(height: 10),
            _buildProfileField('Email', _userEmailController.text),
            const SizedBox(height: 10),
            _buildEditableProfileField('About', _aboutController),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableProfileField(
      String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
            maxLines: label == 'About' ? 3 : 1,
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _saveProfileData,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _selectImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? const Icon(Icons.add_a_photo) : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    // Implement image selection logic here
  }

  Future<void> _saveProfileData() async {
    try {
      final updatedUserData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      };
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // await _databaseController.editUserData(user.uid, updatedUserData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully'),
        ));
      }
    } catch (e) {
      print('Error saving profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update profile'),
      ));
    }
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: UserProfilePage(),
    ),
  );
}
