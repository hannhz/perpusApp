import 'package:flutter/material.dart';
import '../data/dummy_books.dart';
import '../widgets/book_card.dart';
import 'book_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_type_selection_screen.dart';

class HomePustakawan extends StatefulWidget {
  const HomePustakawan({super.key});

  @override
  State<HomePustakawan> createState() => _HomePustakawanState();
}

class _HomePustakawanState extends State<HomePustakawan> {
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  //untuk membuat pop up selamat datang
  String? _username;
  bool _welcomeShown = false;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
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
          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Selamat Datang'),
                    content: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black, // warna teks
                          fontSize: 16.0, // ukuran normal
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
                  ),
            );
          });
          _welcomeShown = true;
        }
      }
    }
  }

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
          'PERPUSTAKAAN',
          style: TextStyle(fontWeight: FontWeight.bold),
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
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            IconData iconData;
            IconData iconDataFilled;
            switch (index) {
              case 0:
                iconData = Icons.home_outlined;
                iconDataFilled = Icons.home;
                break;
              case 1:
                iconData = Icons.add;
                iconDataFilled = Icons.add;
                break;
              case 2:
                iconData = Icons.person_outline;
                iconDataFilled = Icons.person;
                break;
              default:
                iconData = Icons.home_outlined;
                iconDataFilled = Icons.home;
            }

            bool isSelected = _selectedIndex == index;
            bool isHovered = _hoveredIndex == index;

            Color iconColor;
            double iconSize;

            if (isSelected) {
              iconColor = Colors.black87;
              iconSize = 30;
            } else if (isHovered) {
              iconColor = Colors.grey.shade400;
              iconSize = 24;
            } else {
              iconColor = Colors.black54;
              iconSize = 24;
            }

            return MouseRegion(
              onEnter: (_) => _onItemHovered(index, true),
              onExit: (_) => _onItemHovered(index, false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _onItemTapped(index);
                  if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookFormScreen(),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration:
                          isSelected
                              ? BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black87,
                              )
                              : isHovered
                              ? BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade600,
                              )
                              : BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        isSelected ? iconDataFilled : iconData,
                        color:
                            isSelected
                                ? Colors.white
                                : isHovered
                                ? Colors.white
                                : Colors.black54,
                        size: iconSize,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
