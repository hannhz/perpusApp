import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

///import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/book.dart';
import '../widgets/ud_book_card.dart';
import 'book_form_screen.dart';
import 'account_screen.dart';
import '../widgets/library_top_navbar.dart';

class HomePustakawan extends StatefulWidget {
  const HomePustakawan({super.key});

  @override
  State<HomePustakawan> createState() => _HomePustakawanState();
}

class _HomePustakawanState extends State<HomePustakawan> {
  int _selectedIndex = 0;
  int _hoveredIndex = -1;
  bool _isOffline = false;
  String? _username;
  bool _welcomeShown = false;

  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  String _selectedYear = 'Semua';
  String _sortBy = 'A-Z (Judul)';

  Future<List<Book>>? _futureBooks;
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _futureBooks = _fetchBooks();
    _checkConnectivity();
  }

  //Future<void> _loadWelcomeStatus() async {
  //  final prefs = await SharedPreferences.getInstance();
  //  _welcomeShown = prefs.getBool('welcomeShown') ?? false;
  //  await prefs.setBool('welcomeShown', true);
  //}

  void _checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      if (mounted) {
        setState(() {
          _isOffline = result == ConnectivityResult.none;
        });
      }
    });
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        setState(() {
          _username = doc.data()!['username'];
        });

        // Tampilkan pop-up hanya sekali
        if (!_welcomeShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Selamat Datang'),
                    content: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        children: [
                          const TextSpan(text: 'Selamat datang '),
                          TextSpan(
                            text: _username ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' di perpustakaan digital!'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
            );
          });
          _welcomeShown = true;
        }
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredBooks =
          _allBooks.where((book) {
            final matchesSearch = book.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
            final matchesCategory =
                _selectedCategory == 'Semua' || book.genre == _selectedCategory;
            final matchesYear =
                _selectedYear == 'Semua' ||
                book.year.toString() == _selectedYear;
            return matchesSearch && matchesCategory && matchesYear;
          }).toList();

      switch (_sortBy) {
        case 'A-Z (Judul)':
          _filteredBooks.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Z-A (Judul)':
          _filteredBooks.sort((a, b) => b.title.compareTo(a.title));
          break;
        case 'Kategori (A-Z)':
          _filteredBooks.sort((a, b) => a.genre.compareTo(b.genre));
          break;
        case 'Kategori (Z-A)':
          _filteredBooks.sort((a, b) => b.genre.compareTo(a.genre));
          break;
      }
    });
  }

  List<String> _getUniqueYears() {
    final years = _allBooks.map((b) => b.year.toString()).toSet().toList();
    years.sort();
    return years;
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter & Sort',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items:
                        ['Semua', 'Fiksi', 'Non-Fiksi', 'Sains', 'Sejarah']
                            .map(
                              (genre) => DropdownMenuItem(
                                value: genre,
                                child: Text(genre),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) =>
                            setModalState(() => _selectedCategory = value!),
                    decoration: const InputDecoration(labelText: 'Genre'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedYear,
                    items:
                        ['Semua', ..._getUniqueYears()]
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setModalState(() => _selectedYear = value!),
                    decoration: const InputDecoration(labelText: 'Tahun'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _sortBy,
                    items:
                        [
                              'A-Z (Judul)',
                              'Z-A (Judul)',
                              'Kategori (A-Z)',
                              'Kategori (Z-A)',
                            ]
                            .map(
                              (sort) => DropdownMenuItem(
                                value: sort,
                                child: Text(sort),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setModalState(() => _sortBy = value!),
                    decoration: const InputDecoration(
                      labelText: 'Urutkan berdasarkan',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: const Text('Terapkan'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onItemTapped(int index) async {
    if (index == 0) {
      setState(() {
        _selectedIndex = 0;
        _hoveredIndex = -1;
        _futureBooks = _fetchBooks();
      });
    } else if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookFormScreen()),
      );
      setState(() {
        _selectedIndex = 0;
        _hoveredIndex = -1;
        _futureBooks = _fetchBooks();
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountPage()),
      );
    }
  }

  void _onItemHovered(int index, bool isHovered) {
    if (mounted) {
      setState(() => _hoveredIndex = isHovered ? index : -1);
    }
  }

  Future<List<Book>> _fetchBooks() async {
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
    final books =
        snapshot.docs
            .map((doc) => Book.fromFirestore(doc.data(), documentId: doc.id))
            .toList();
    _allBooks = books;
    _applyFilters();
    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:
          const LibraryTopNavbar(), // Kembali ke appbar biasa tanpa username
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
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
            ),
            const SizedBox(height: 16),
            if (_isOffline)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Anda sedang offline. Beberapa fitur mungkin tidak tersedia.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || _filteredBooks.isEmpty) {
                    return const Center(child: Text('Tidak ada buku.'));
                  }
                  return ListView.builder(
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      return UdBookCard(
                        book: _filteredBooks[index],
                        documentId: _filteredBooks[index].documentId ?? '',
                        onBookUpdated: () {
                          _futureBooks = _fetchBooks();
                          setState(() {});
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
}
