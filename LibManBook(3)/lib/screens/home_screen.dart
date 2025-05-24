import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../models/user_type.dart';
import 'user_type_selection_screen.dart';
import 'aboutUS_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserType userType;

  const HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedGenre = 'Semua';
  String _selectedSort = 'A-Z';

  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  Future<List<Book>>? _futureBooks;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Coba login anonymous hanya jika diperlukan
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
        debugPrint('Anonymous user: ${FirebaseAuth.instance.currentUser?.uid}');
      }
      _loadBooks();
    } catch (e) {
      debugPrint('Auth failed, loading books anyway: $e');
      _loadBooks(); // Tetap coba load buku meskipun auth gagal
    }
  }

  // Pisahkan logika load buku
  Future<void> _loadBooks() async {
    try {
      _futureBooks = _fetchBooks();
      final books = await _futureBooks!;
      setState(() {
        _allBooks = books;
      });
      _applyFilters(); // <- ini penting!
    } catch (e) {
      debugPrint('Book load error: $e');
      setState(() {
        _futureBooks = Future.value([]);
      });
    }
  }

  /// Modifikasi fetchBooks untuk lebih toleran
  Future<List<Book>> _fetchBooks() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('books')
          .get(const GetOptions(source: Source.serverAndCache));

      return snapshot.docs.map((doc) {
        try {
          return Book.fromFirestore(doc.data(), documentId: doc.id);
        } catch (e) {
          debugPrint('Error parsing book ${doc.id}: $e');
          return Book.empty(); // Pastikan ada fallback Book.empty()
        }
      }).toList();
    } catch (e) {
      debugPrint('Fetch books error: $e');
      return []; // Return empty list instead of throwing
    }
  }

  /// Apply search, genre filter, and sorting to the book list
  void _applyFilters() {
    setState(() {
      _filteredBooks =
          _allBooks.where((book) {
            final matchesSearch = book.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
            final matchesGenre =
                _selectedGenre == 'Semua' || book.genre == _selectedGenre;
            return matchesSearch && matchesGenre;
          }).toList();

      switch (_selectedSort) {
        case 'A-Z':
          _filteredBooks.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Z-A':
          _filteredBooks.sort((a, b) => b.title.compareTo(a.title));
          break;
        case 'Tahun Terbaru':
          _filteredBooks.sort((a, b) => b.year.compareTo(a.year));
          break;
        case 'Tahun Terlama':
          _filteredBooks.sort((a, b) => a.year.compareTo(b.year));
          break;
      }
    });
  }

  /// Show modal bottom sheet with filter options
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildFilterOptions(),
    );
  }

  /// Build the filter options widget for the modal bottom sheet
  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _genreDropdown(),
          const SizedBox(height: 12),
          _sortDropdown(),
        ],
      ),
    );
  }

  /// Dropdown widget for selecting genre filter
  Widget _genreDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _selectedGenre,
      items:
          ['Semua', 'Fiksi', 'Non-Fiksi', 'Biografi', 'Teknologi']
              .map(
                (genre) => DropdownMenuItem(value: genre, child: Text(genre)),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGenre = value!;
        });
        _applyFilters();
        Navigator.pop(context);
      },
    );
  }

  /// Dropdown widget for selecting sort order
  Widget _sortDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _selectedSort,
      items:
          ['A-Z', 'Z-A', 'Tahun Terbaru', 'Tahun Terlama']
              .map((sort) => DropdownMenuItem(value: sort, child: Text(sort)))
              .toList(),
      onChanged: (value) {
        setState(() {
          _selectedSort = value!;
        });
        _applyFilters();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.menu_book),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserTypeSelectionScreen(),
              ),
            );
          },
        ),
        title: const Text(
          'PERPUSTAKAAN',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'CARI JUDUL DISINI ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterOptions,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _applyFilters();
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || _filteredBooks.isEmpty) {
                    return const Center(child: Text('Tidak ada buku.'));
                  }
                  return ListView.builder(
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      return BookCard(
                        book: _filteredBooks[index],
                        documentId: _filteredBooks[index].documentId ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: null,
    );
  }
}
