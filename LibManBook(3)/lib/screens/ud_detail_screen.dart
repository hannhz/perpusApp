import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class UdDetailScreen extends StatefulWidget {
  final Book book;
  final String documentId;

  const UdDetailScreen({
    super.key,
    required this.book,
    required this.documentId,
  });

  @override
  State<UdDetailScreen> createState() => _UdDetailScreenState();
}

class _UdDetailScreenState extends State<UdDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _shelfController;
  late TextEditingController _coverController;
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _yearController;
  late TextEditingController _genreController;
  late TextEditingController _synopsisController;
  late String _category;
  late bool _available;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _shelfController = TextEditingController(text: widget.book.shelf);
    _coverController = TextEditingController(text: widget.book.cover);
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _yearController = TextEditingController(text: widget.book.year.toString());
    _genreController = TextEditingController(text: widget.book.genre);
    _synopsisController = TextEditingController(text: widget.book.synopsis);
    _category =
        widget.book.category.isNotEmpty ? widget.book.category : 'Anak-anak';
    _available = widget.book.available;
  }

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

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('books')
            .doc(widget.documentId)
            .update(_prepareBookData());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buku berhasil diperbarui')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memperbarui buku: $e')));
      }
    }
  }

  Map<String, dynamic> _prepareBookData() {
    return {
      'shelf': _shelfController.text,
      'cover': _coverController.text,
      'title': _titleController.text,
      'author': _authorController.text,
      'year': int.tryParse(_yearController.text) ?? 0,
      'genre': _genreController.text,
      'synopsis': _synopsisController.text,
      'category': _category,
      'available': _available,
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  Future<void> _deleteBook() async {
    try {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(widget.documentId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Buku berhasil dihapus')));

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus buku: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Buku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF800000)),
            tooltip: 'Hapus',
            onPressed: _deleteBook,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Shelf Input
                _buildShelfInput(),
                const SizedBox(height: 16),

                // Cover Image
                _buildCoverImage(),
                const SizedBox(height: 8),

                // Cover URL Input
                _buildCoverUrlInput(),
                const SizedBox(height: 16),

                // Title Input
                _buildTitleInput(),
                const SizedBox(height: 8),

                // Author Input
                _buildAuthorInput(),
                const SizedBox(height: 8),

                // Year Input
                _buildYearInput(),
                const SizedBox(height: 8),

                // Category Dropdown
                _buildCategoryDropdown(),
                const SizedBox(height: 8),

                // Genre Input
                _buildGenreInput(),
                const SizedBox(height: 8),

                // Synopsis Input
                _buildSynopsisInput(),
                const SizedBox(height: 16),

                // Availability Switch
                _buildAvailabilitySwitch(),
                const SizedBox(height: 24),

                // Update Button
                _buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShelfInput() {
    return TextFormField(
      controller: _shelfController,
      decoration: InputDecoration(
        labelText: 'Rak Buku',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[800] ?? Colors.grey, // Tambahkan null check
        labelStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) => value?.isEmpty ?? true ? 'Masukkan rak buku' : null,
    );
  }

  Widget _buildCoverImage() {
    return Center(
      child: Container(
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image:
                _coverController.text.isNotEmpty
                    ? NetworkImage(_coverController.text)
                    : const AssetImage('assets/images/logo_splash.png')
                        as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCoverUrlInput() {
    return TextFormField(
      controller: _coverController,
      decoration: const InputDecoration(
        labelText: 'URL Cover',
        border: OutlineInputBorder(),
      ),
      validator:
          (value) => value?.isEmpty ?? true ? 'Masukkan URL cover' : null,
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildTitleInput() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Judul Buku',
        border: OutlineInputBorder(),
      ),
      validator:
          (value) => value?.isEmpty ?? true ? 'Masukkan judul buku' : null,
    );
  }

  Widget _buildAuthorInput() {
    return TextFormField(
      controller: _authorController,
      decoration: const InputDecoration(
        labelText: 'Penulis',
        border: OutlineInputBorder(),
      ),
      validator:
          (value) => value?.isEmpty ?? true ? 'Masukkan nama penulis' : null,
    );
  }

  Widget _buildYearInput() {
    return TextFormField(
      controller: _yearController,
      decoration: const InputDecoration(
        labelText: 'Tahun Terbit',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Masukkan tahun terbit';
        final year = int.tryParse(value!);
        if (year == null || year < 0) return 'Masukkan tahun yang valid';
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'Anak-anak', child: Text('Anak-anak')),
        DropdownMenuItem(value: 'Remaja', child: Text('Remaja')),
        DropdownMenuItem(value: 'Dewasa', child: Text('Dewasa')),
        DropdownMenuItem(value: 'Segala Umur', child: Text('Segala Umur')),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _category = value);
      },
      validator: (value) => value?.isEmpty ?? true ? 'Pilih kategori' : null,
    );
  }

  Widget _buildGenreInput() {
    return TextFormField(
      controller: _genreController,
      decoration: const InputDecoration(
        labelText: 'Genre',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Masukkan genre' : null,
    );
  }

  Widget _buildSynopsisInput() {
    return TextFormField(
      controller: _synopsisController,
      decoration: const InputDecoration(
        labelText: 'Sinopsis',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) => value?.isEmpty ?? true ? 'Masukkan sinopsis' : null,
    );
  }

  Widget _buildAvailabilitySwitch() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[100], // warna card
      child: SwitchListTile(
        title: const Text(
          'Status Ketersediaan',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ), // warna teks title
        ),
        subtitle: Text(
          _available ? 'Tersedia' : 'Dipinjam',
          style: const TextStyle(
            color: Color.fromARGB(179, 100, 100, 100),
          ), // warna teks subtitle
        ),
        value: _available,
        activeColor: Colors.grey[500],
        inactiveThumbColor: Colors.grey[700],
        inactiveTrackColor: Colors.grey[900],
        onChanged: (value) => setState(() => _available = value),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100], // warna tombol
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _updateBook,
        child: const Text(
          'PERBARUI BUKU',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ), // warna teks tombol
        ),
      ),
    );
  }
}
