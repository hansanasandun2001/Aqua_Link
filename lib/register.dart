import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nicController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isEmailVerified = false;

  // File variables
  File? _nicFrontFile;
  File? _nicBackFile;
  File? _selfieFile;
  String? _nicFrontFileName;
  String? _nicBackFileName;
  String? _selfieFileName;

  List<String> _selectedRoles = [];

  final List<String> _roles = [
    'Shop Owner',
    'Farm Owner',
    'Collector',
    'Service Provider',
    'Industrial Stuff Seller',
    'Delivery Person',
  ];

  @override
  void dispose() {
    _nicController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOTP() {
    if (_emailController.text.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP sent to your email')));
    }
  }

  void _verifyEmail() {
    setState(() {
      _isEmailVerified = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email verified successfully')),
    );
  }

  void _toggleRole(String role) {
    setState(() {
      if (_selectedRoles.contains(role)) {
        _selectedRoles.remove(role);
      } else {
        _selectedRoles.add(role);
      }
    });
  }

  // File picker methods
  Future<void> _pickNicFrontFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Check file size (5MB limit)
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File size must be less than 5MB')),
          );
          return;
        }

        setState(() {
          _nicFrontFile = file;
          _nicFrontFileName = result.files.single.name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NIC Front image selected successfully'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  Future<void> _pickNicBackFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Check file size (5MB limit)
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File size must be less than 5MB')),
          );
          return;
        }

        setState(() {
          _nicBackFile = file;
          _nicBackFileName = result.files.single.name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NIC Back image selected successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  Future<void> _pickSelfieFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Check file size (5MB limit)
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File size must be less than 5MB')),
          );
          return;
        }

        setState(() {
          _selfieFile = file;
          _selfieFileName = result.files.single.name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selfie image selected successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRoles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one role')),
        );
        return;
      }

      if (!_isEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email first')),
        );
        return;
      }

      if (_nicFrontFile == null ||
          _nicBackFile == null ||
          _selfieFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload all required documents')),
        );
        return;
      }

      // Here you can process the registration with all the data
      // including the uploaded files
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00BCD4), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),

                // Title and Subtitle
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join our platform and start your journey',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 32),

                // NIC Number Field
                _buildTextField(
                  controller: _nicController,
                  label: 'NIC Number',
                  hint: 'Enter your NIC number',
                  suffixIcon: Icons.credit_card,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your NIC number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Full Name Field
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  suffixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Address Field with OTP
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your email address',
                              suffixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _sendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Send OTP'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Phone Number Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  suffixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Select Roles
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Your Role(s)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._roles
                        .map(
                          (role) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () => _toggleRole(role),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedRoles.contains(role)
                                        ? const Color(0xFF6366F1)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _selectedRoles.contains(role),
                                      onChanged: (_) => _toggleRole(role),
                                      activeColor: const Color(0xFF6366F1),
                                    ),
                                    Text(
                                      role,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
                const SizedBox(height: 16),

                // Password Fields
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter password',
                  suffixIcon: _passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  obscureText: !_passwordVisible,
                  onSuffixTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm password',
                  suffixIcon: _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  obscureText: !_confirmPasswordVisible,
                  onSuffixTap: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // NIC Document Upload
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NIC Document Upload',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildUploadContainer(
                          icon: Icons.credit_card_outlined,
                          title: 'Front Side',
                          uploadText: 'Upload Front',
                          selectedFileName: _nicFrontFileName,
                          onTap: _pickNicFrontFile,
                          isSelected: _nicFrontFile != null,
                        ),
                        const SizedBox(width: 8),
                        _buildUploadContainer(
                          icon: Icons.credit_card_outlined,
                          title: 'Back Side',
                          uploadText: 'Upload Back',
                          selectedFileName: _nicBackFileName,
                          onTap: _pickNicBackFile,
                          isSelected: _nicBackFile != null,
                        ),
                        const SizedBox(width: 8),
                        _buildUploadContainer(
                          icon: Icons.person_outline,
                          title: 'Selfie',
                          uploadText: 'Upload Selfie',
                          selectedFileName: _selfieFileName,
                          onTap: _pickSelfieFile,
                          isSelected: _selfieFile != null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PNG, JPG, JPEG up to 5MB',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Verify Email Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isEmailVerified ? null : _verifyEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isEmailVerified
                          ? Colors.green
                          : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isEmailVerified ? Icons.check : Icons.email),
                        const SizedBox(width: 8),
                        Text(
                          _isEmailVerified
                              ? 'Email Verified'
                              : 'Verify Email First',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Sign in here',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData suffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onSuffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: GestureDetector(
              onTap: onSuffixTap,
              child: Icon(suffixIcon),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadContainer({
    required IconData icon,
    required String title,
    required String uploadText,
    required String? selectedFileName,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? const Color(0xFF6366F1) : Colors.grey[300]!,
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? const Color(0xFF6366F1).withOpacity(0.1)
                : Colors.grey[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.check_circle : icon,
                size: 40,
                color: isSelected ? const Color(0xFF6366F1) : Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                isSelected ? 'Selected' : uploadText,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? const Color(0xFF6366F1) : Colors.black54,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected && selectedFileName != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    selectedFileName.length > 15
                        ? '${selectedFileName.substring(0, 15)}...'
                        : selectedFileName,
                    style: const TextStyle(fontSize: 10, color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
