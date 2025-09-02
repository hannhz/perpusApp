import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bottom_nav_bar.dart';
//import '../widgets/library_top_navbar.dart';
import 'account_screen.dart';
import 'home_pustakawan.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _shelfController = TextEditingController();
  final TextEditingController _coverController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();

  String? _selectedCategory;

  @override
  void dispose() {
    _shelfController.dispose();
    _coverController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final bookData = {
        'shelf': _shelfController.text,
        'cover_url': _coverController.text,
        'title': _titleController.text,
        'author': _authorController.text,
        'year': int.parse(_yearController.text),
        'category': _selectedCategory ?? '',
        'genre': _genreController.text,
        'synopsis': _synopsisController.text,
        'created_at': FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance.collection('books').add(bookData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data buku sudah terikirim dan tersimpan!'),
          ),
        );

        // Optional: Clear the form
        _formKey.currentState!.reset();
        _shelfController.clear();
        _coverController.clear();
        _titleController.clear();
        _authorController.clear();
        _yearController.clear();
        _genreController.clear();
        _synopsisController.clear();
        setState(() => _selectedCategory = null);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tambahkan buku baru',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cover image preview
                Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          _coverController.text.isNotEmpty
                              ? NetworkImage(_coverController.text)
                              : const AssetImage(
                                    'assets/images/logo_splash.png',
                                  )
                                  as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Shelf input styled like Chip
                TextFormField(
                  controller: _shelfController,
                  decoration: InputDecoration(
                    labelText: 'Rak Buku',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Masukkan rak buku'
                              : null,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _coverController,
                  decoration: const InputDecoration(
                    labelText: 'Cover URL',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter cover URL'
                              : null,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul (Title)',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter title'
                              : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Penulis (Author)',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter author'
                              : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Tahun (Year)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter year';
                    }
                    final year = int.tryParse(value);
                    if (year == null || year < 0) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kategori Buku',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: const [
                    DropdownMenuItem(
                      value: 'Anak-anak',
                      child: Text('Anak-anak'),
                    ),
                    DropdownMenuItem(value: 'Remaja', child: Text('Remaja')),
                    DropdownMenuItem(value: 'Dewasa', child: Text('Dewasa')),
                    DropdownMenuItem(
                      value: 'Segala Umur',
                      child: Text('Segala Umur'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please select a category'
                              : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _genreController,
                  decoration: const InputDecoration(
                    labelText: 'Genre',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter genre'
                              : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _synopsisController,
                  decoration: const InputDecoration(
                    labelText: 'Sinopsis (Synopsis)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter synopsis'
                              : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(
                      255,
                      0,
                      0,
                      0,
                    ), // Text color
                    backgroundColor: Colors.white, // Button background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ), // Border color
                    ),
                  ),
                  child: const Text(
                    'TAMBAHKAN BUKU',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1, // Assuming 1 is the index for this screen
        hoveredIndex: -1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePustakawan()),
            );
          } else if (index == 1) {
            // Current screen, do nothing or refresh if needed
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AccountPage()),
            );
          }
        },
        onItemHovered: (index, isHovered) {
          // Handle hover if needed
        },
      ),
    );
  }
}
