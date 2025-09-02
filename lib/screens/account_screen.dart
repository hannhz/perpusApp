import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_type_selection_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_pustakawan.dart';
import 'book_form_screen.dart';

import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _obscurePassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(
    text: '••••••••',
  );

  int _selectedIndex = 2; // Account page is index 2
  int _hoveredIndex = -1;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();

      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePustakawan()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookFormScreen()),
      );
    } else if (index == 2) {
      // Current screen, do nothing or refresh if needed
    }
    setState(() {
      _selectedIndex = index;
      _hoveredIndex = -1;
    });
  }

  void _onItemHovered(int index, bool isHovered) {
    setState(() {
      _hoveredIndex = isHovered ? index : -1;
    });
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        _nameController.text = doc['username'] ?? '';
      }
      if (doc.data()!.containsKey('photoBase64')) {
        setState(() {
          _base64Image = doc['photoBase64'];
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newEmail = _emailController.text.trim();
    final newPassword = _passwordController.text.trim();
    final currentEmail = user.email ?? '';

    String? currentPassword = await _promptForPassword();
    if (currentPassword == null || currentPassword.isEmpty) return;

    try {
      final cred = EmailAuthProvider.credential(
        email: currentEmail,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);

      if (newEmail != currentEmail) {
        await user.updateEmail(newEmail);
      }

      if (newPassword != '••••••••' && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': _nameController.text,
        if (_base64Image != null) 'photoBase64': _base64Image,
      }, SetOptions(merge: true));

      if (mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Perubahan sudah disimpan!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Okey'),
                  ),
                ],
              ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Gagal'),
                content: Text(e.message ?? 'Hmm.. ada yang salah'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Okey'),
                  ),
                ],
              ),
        );
      }
    }
  }

  Future<String?> _promptForPassword() async {
    String password = '';
    return await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Konfirmasi perubahan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Masukin passwordmu buat lanjut.'),
              TextField(
                obscureText: true,
                onChanged: (val) => password = val,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, password),
              child: const Text('Lanjut'),
            ),
          ],
        );
      },
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
      if (!_obscurePassword && _passwordController.text == '••••••••') {
        _passwordController.text = '';
      } else if (_obscurePassword && _passwordController.text.isEmpty) {
        _passwordController.text = '••••••••';
      }
    });
  }

  void _signOut() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Keluar'),
            content: const Text('Kamu yakin mau keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserTypeSelectionScreen(),
                      ),
                      (route) => false,
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Kamu berhasil keluar, jangan lupa balik lagi ya!',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Akunku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 55, 55, 55),
                          const Color.fromARGB(255, 70, 32, 32),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child:
                        _base64Image != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                base64Decode(_base64Image!),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Color.fromARGB(255, 97, 97, 97),
                    ), // Grey camera icon
                    label: const Text(
                      'Ganti Foto',
                      style: TextStyle(
                        color: Color.fromARGB(255, 97, 97, 97), // Grey text
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Akun',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Nama Lengkap',
                      controller: _nameController,
                      icon: Icons.edit,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Alamat Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.edit,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _togglePasswordVisibility,
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                        foregroundColor: Colors.white, // White text and icon
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            size: 16,
                            color: Colors.white,
                          ), // White save icon
                          SizedBox(width: 8),
                          Text('Simpan perubahan'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _signOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 70, 32, 32),
                        foregroundColor: Colors.white, // White text and icon
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 16,
                            color: Colors.white,
                          ), // White logout icon
                          SizedBox(width: 8),
                          Text('Keluar'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        hoveredIndex: _hoveredIndex,
        onItemTapped: _onItemTapped,
        onItemHovered: _onItemHovered,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(icon, size: 16),
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
