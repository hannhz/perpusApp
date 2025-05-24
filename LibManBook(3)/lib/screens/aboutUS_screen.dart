import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tentang Kami',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const AboutUsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Tentang Kami',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildLibrarySection(),
            const SizedBox(height: 24),
            _buildTeamSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Kelompok 1; TRM A',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tim yang dibuat untuk mengembangkan aplikasi mobile dengan tujuan untuk memenuhi penilaian akhir matakuliah Mobile Programming',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.black54,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibrarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.school, color: Colors.black54),
            SizedBox(width: 8),
            Text(
              'Pendidikan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Program Studi Sarjana Terapan Teknologi Rekayasa Multimedia, Politeknik Elektronika Negeri Surabaya.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.people, color: Colors.black54),
            SizedBox(width: 8),
            Text(
              'Anggota tim',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Diubah: HAPUS Expanded, cukup list biasa
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamMember(
              'Ahmad Nur Fuady',
              '5323600005',
              Colors.grey.shade800,
            ),
            _buildTeamMember(
              'Rakha Zahran Andrian',
              '5323600014',
              Colors.grey.shade700,
            ),
            _buildTeamMember(
              'Hanan Hafizhah Zarkasi',
              '5323600015',
              Colors.grey.shade600,
            ),
            _buildTeamMember(
              'Muhammad Bayu Iskandar',
              '5323600025',
              Colors.grey.shade700,
            ),
            _buildTeamMember(
              'Annisa Farah Angelin',
              '5323600027',
              Colors.grey.shade800,
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildTeamMember(String name, String role, Color color) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                role,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
