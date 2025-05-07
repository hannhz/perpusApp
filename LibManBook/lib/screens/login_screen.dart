import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'home_pustakawan.dart';
import 'user_type_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //menampilkan loading
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // dismiss loading dialog
    }
  }

  //terhubung ke firebase
  void _login() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog(); // tampilkan loading
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        _hideLoadingDialog();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePustakawan()),
        );
      } on FirebaseAuthException catch (e) {
        _hideLoadingDialog();
        String message = '';
        if (e.code == 'user-not-found') {
          message = 'Pengguna tidak ditemukan.';
        } else if (e.code == 'wrong-password') {
          message = 'Password salah.';
        } else {
          message = 'Login gagal. ${e.message}';
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
    );
  }

  void _goBackToUserSelection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserTypeSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _goBackToUserSelection,
                    icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
                    label: Text(
                      'Kembali',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Logo and Title
                Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 48,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manajemen Perpustakaan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Laman Pustakawan',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                          ).hasMatch(value)) {
                            return 'Masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text('Ingat Saya'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password functionality
                            },
                            child: Text(
                              'Lupa password?',
                              style: TextStyle(
                                color: Colors.blue[700],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum Punya Akun? '),
                    TextButton(
                      onPressed: _goToRegister,
                      child: Text(
                        'Daftar Disini',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
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
}
