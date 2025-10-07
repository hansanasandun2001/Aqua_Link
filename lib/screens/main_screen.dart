import 'dart:io';

import 'package:aqua_link/authentication/login.dart';
import 'package:aqua_link/pages/about_page.dart';
import 'package:aqua_link/pages/cart_page.dart';
import 'package:aqua_link/pages/contact_page.dart';
import 'package:aqua_link/pages/home_page.dart';
import 'package:aqua_link/pages/my_profile_page.dart';
import 'package:aqua_link/pages/profile_page.dart';
import 'package:aqua_link/services/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  XFile? _selectedImage;
  String _businessName = '';
  String _businessAddress = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _onPressedNavItems(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadProfileData() async {
    final businessName = await ProfileService.getBusinessName();
    final address = await ProfileService.getAddress();
    final imagePath = await ProfileService.getProfileImage();

    setState(() {
      _businessName = businessName ?? 'Business Name';

      // Format address string
      final addressParts = <String>[];
      if (address['place']?.isNotEmpty == true) addressParts.add(address['place']!);
      if (address['street']?.isNotEmpty == true) addressParts.add(address['street']!);
      if (address['district']?.isNotEmpty == true) addressParts.add(address['district']!);
      if (address['town']?.isNotEmpty == true) addressParts.add(address['town']!);

      _businessAddress = addressParts.isNotEmpty
          ? addressParts.join(', ')
          : 'Add your business address';

      if (imagePath != null && imagePath.isNotEmpty) {
        _selectedImage = XFile(imagePath);
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
      // Save image path
      await ProfileService.saveProfileImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 220, 237),
        title: const Text('AquaLink', style: TextStyle(fontSize: 24)),
        centerTitle: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(),
          ProfilePage(),
          CartPage(),
          AboutPage(),
          ContactPage(),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 115, 218, 230),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircleAvatar(
                                    backgroundImage: _selectedImage != null
                                        ? (kIsWeb
                                        ? NetworkImage(_selectedImage!.path)
                                        : FileImage(File(_selectedImage!.path)))
                                    as ImageProvider
                                        : null,
                                    child: _selectedImage == null
                                        ? Icon(Icons.person, size: 40)
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                    ),
                                    child: InkWell(
                                      onTap: _pickImage,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(Icons.camera_alt_rounded, size: 20,),
                                      ),
                                    )
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _businessName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _businessAddress,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_2_outlined),
                    title: Text('My Profile'),
                    onTap: () async {
                      Navigator.pop(context); // Close drawer first
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyProfilePage()),
                      );
                      // Reload profile data when returning from profile page
                      _loadProfileData();
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 82, 220, 237),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_support),
            label: 'Contact',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onPressedNavItems,
      ),
    );
  }
}