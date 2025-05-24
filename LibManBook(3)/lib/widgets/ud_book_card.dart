import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/ud_detail_screen.dart';

class UdBookCard extends StatefulWidget {
  final Book book;
  final String documentId;
  final VoidCallback onBookUpdated;

  const UdBookCard({
    super.key,
    required this.book,
    required this.documentId,
    required this.onBookUpdated,
  });

  @override
  State<UdBookCard> createState() => _UdBookCardState();
}

class _UdBookCardState extends State<UdBookCard> {
  bool _isHovering = false;
  late Book _currentBook;

  @override
  void initState() {
    super.initState();
    _currentBook = widget.book;
  }

  void _onEnter(PointerEvent details) {
    setState(() => _isHovering = true);
  }

  void _onExit(PointerEvent details) {
    setState(() => _isHovering = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final updatedBook = await Navigator.push<Book?>(
            context,
            MaterialPageRoute(
              builder:
                  (context) => UdDetailScreen(
                    book: _currentBook,
                    documentId: widget.documentId,
                  ),
            ),
          );
          if (updatedBook != null && mounted) {
            setState(() => _currentBook = updatedBook);
            widget.onBookUpdated();
          }
        },
        child: Card(
          color: Colors.grey[100],
          elevation: _isHovering ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Book Cover with shadow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _currentBook.cover.isNotEmpty
                          ? _currentBook.cover
                          : 'https://via.placeholder.com/80x120',
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logo_splash.png',
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shelf label with availability indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _currentBook.available
                                  ? Colors.grey[800]
                                  : const Color(0xFF800000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currentBook.shelf,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Book Title
                      Text(
                        _currentBook.title.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Author and Year
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _currentBook.author,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${_currentBook.year}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Synopsis
                      Text(
                        _currentBook.synopsis,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Category and Genre
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _currentBook.category,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _currentBook.genre,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
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
