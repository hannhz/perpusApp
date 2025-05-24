import 'package:flutter/material.dart';
import '../screens/aboutUS_screen.dart';

class LibraryTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  const LibraryTopNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[100],
      leading: const Icon(Icons.menu_book),
      title: const Text(
        'PERPUSTAKAAN',
        style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
