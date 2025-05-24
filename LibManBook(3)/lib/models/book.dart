class Book {
  final String? documentId;
  final String title;
  final String author;
  final int year;
  final String category;
  final String genre;
  final String shelf;
  final bool available;
  final String synopsis;
  final String cover;

  Book({
    this.documentId,
    required this.title,
    required this.author,
    required this.year,
    required this.category,
    required this.genre,
    required this.shelf,
    required this.available,
    required this.synopsis,
    required this.cover,
  });

  factory Book.fromFirestore(Map<String, dynamic> data, {String? documentId}) {
    return Book(
      documentId: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      year: data['year'] ?? 0,
      category: data['category'] ?? '',
      genre: data['genre'] ?? '',
      shelf: data['shelf'] ?? '',
      available: data['available'] ?? true,
      synopsis: data['synopsis'] ?? '',
      cover: data['cover_url'] ?? '',
    );
  }

  factory Book.empty() {
    return Book(
      title: '',
      author: '',
      year: 0,
      category: '',
      genre: '',
      shelf: '',
      available: true,
      synopsis: '',
      cover: '',
    );
  }
}
