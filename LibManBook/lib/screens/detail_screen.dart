import 'package:flutter/material.dart';
import '../models/book.dart';

class DetailScreen extends StatelessWidget {
  final Book book;

  const DetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('DETAIL', style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Chip(
                label: Text(book.shelf, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
              ),
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(book.cover),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                book.title.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                book.author,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              Text('${book.year}'),
              Text(book.category),
              Text(book.genre),
              const SizedBox(height: 16),
              Text(
                book.synopsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
