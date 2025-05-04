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
      // For now, just print the values to console
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
      appBar: AppBar(title: const Text('Add New Book')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _shelfController,
                  decoration: const InputDecoration(
                    labelText: 'Rak Buku (Shelf)',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter shelf'
                              : null,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
