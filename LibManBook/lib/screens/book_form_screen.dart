import 'package:flutter/material.dart';

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

  double _rating = 3.0;

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Shelf: ${_shelfController.text}');
      print('Cover URL: ${_coverController.text}');
      print('Title: ${_titleController.text}');
      print('Author: ${_authorController.text}');
      print('Year: ${_yearController.text}');
      print('Rating: $_rating');
      print('Genre: ${_genreController.text}');
      print('Synopsis: ${_synopsisController.text}');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Book data submitted')));
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
          'Add New Book',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Shelf input styled like Chip
                TextFormField(
                  controller: _shelfController,
                  decoration: InputDecoration(
                    labelText: 'Rak Buku (Shelf)',
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
                              ? 'Please enter shelf'
                              : null,
                ),
                const SizedBox(height: 16),
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
                Row(
                  children: [
                    const Text('Rating:'),
                    Expanded(
                      child: Slider(
                        value: _rating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: _rating.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                      ),
                    ),
                  ],
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
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
