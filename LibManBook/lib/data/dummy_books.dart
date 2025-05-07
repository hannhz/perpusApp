import '../models/book.dart';

List<Book> dummyBooks = List.generate(5, (index) {
  return Book(
    title: 'LOREM IPSUM DOLOR SIT AMET',
    author: 'F. Ahmad Nur',
    year: 2029,
    category: 'Remaja',
    genre: 'Fantasi/Comedy/Slice of life',
    shelf: 'Novel/${index + 1}',
    available: true,
    synopsis:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    cover: 'https://via.placeholder.com/100x150.png?text=Book+Cover',
  );
});
