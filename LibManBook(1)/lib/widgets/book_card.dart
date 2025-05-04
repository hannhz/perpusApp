import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/detail_screen.dart';

class BookCard extends StatefulWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _isHovering = false;

  void _onEnter(PointerEvent details) {
    setState(() {
      _isHovering = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(book: widget.book),
            ),
          );
        },
        child: Card(
          elevation: _isHovering ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Image.network(
                  widget.book.cover,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.book.shelf,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.book.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.book.author,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text('${widget.book.year}'),
                      const SizedBox(height: 4),
                      Text(
                        widget.book.synopsis,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text('${widget.book.category}'),
                      Text(widget.book.genre),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
