import 'dart:io';

import 'package:aqua_link/services/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  XFile? _selectedImage;

  // Text controllers for form fields
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _townController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _placeController.dispose();
    _streetController.dispose();
    _districtController.dispose();
    _townController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final businessName = await ProfileService.getBusinessName();
    final address = await ProfileService.getAddress();
    final imagePath = await ProfileService.getProfileImage();

    setState(() {
      _businessNameController.text = businessName ?? '';
      _placeController.text = address['place'] ?? '';
      _streetController.text = address['street'] ?? '';
      _districtController.text = address['district'] ?? '';
      _townController.text = address['town'] ?? '';

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
      // Save image path immediately
      await ProfileService.saveProfileImage(pickedFile.path);
    }
  }

  Future<void> _saveProfile() async {
    try {
      // Save business name
      await ProfileService.saveBusinessName(_businessNameController.text);

      // Save address
      await ProfileService.saveAddress(
        place: _placeController.text,
        street: _streetController.text,
        district: _districtController.text,
        town: _townController.text,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Business Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: _selectedImage != null
                          ? (kIsWeb
                          ? NetworkImage(_selectedImage!.path)
                          : FileImage(File(_selectedImage!.path)))
                      as ImageProvider
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 12,
                      left: 120,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          child: InkWell(
                            onTap: _pickImage,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.camera_alt_rounded, size: 28,),
                            ),
                          )
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Business Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your business name',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Business Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _placeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Place (House No.)')
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _streetController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Street')
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _districtController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('District')
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _townController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Town')
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 82, 220, 237),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
