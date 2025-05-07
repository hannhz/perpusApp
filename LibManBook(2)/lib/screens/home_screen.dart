import 'package:flutter/material.dart';
import '../data/dummy_books.dart';
import '../widgets/book_card.dart';

import '../models/user_type.dart';
import 'user_type_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserType userType;

  const HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemHovered(int index, bool isHovered) {
    setState(() {
      _hoveredIndex = isHovered ? index : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
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
          'PERPUSTAKAAAN',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'CARI DISINI ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: dummyBooks.length,
                itemBuilder: (context, index) {
                  return BookCard(book: dummyBooks[index]);
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
